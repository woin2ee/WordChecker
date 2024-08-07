//
//  Created by Jaewon Yun on 2023/09/22.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain_Core
import Domain_GoogleDrive
import Domain_LocalNotification
import Domain_WordManagement
import Domain_WordMemorization
import Foundation
import RxSwift
import RxSwiftSugar

internal final class DefaultGoogleDriveUseCase: GoogleDriveUseCase {

    private let googleDriveService: GoogleDriveService
    private let wordService: WordManagementService
    private let wordMemorizationService: WordMemorizationService
    private let localNotificationService: LocalNotificationService

    init(googleDriveService: GoogleDriveService, wordService: WordManagementService, wordMemorizationService: WordMemorizationService, localNotificationService: LocalNotificationService) {
        self.googleDriveService = googleDriveService
        self.wordService = wordService
        self.wordMemorizationService = wordMemorizationService
        self.localNotificationService = localNotificationService
    }

    func signInWithAuthorization(presenting: PresentingConfiguration) -> RxSwift.Single<Email?> {
        if hasSigned, googleDriveService.isGrantedAppDataScope {
            return .just(googleDriveService.currentUserEmail)
        }

        return googleDriveService.restorePreviousSignIn()
            .flatMap { email in
                return self.googleDriveService.requestAppDataScopeAccess(presenting: presenting)
                    .map { email }
            }
            .catch { _ in self.googleDriveService.signInWithAppDataScope(presenting: presenting) }
    }

    func signOut() {
        googleDriveService.signOut()
    }

    var currentUserEmail: Email? {
        googleDriveService.currentUserEmail
    }
    
    var hasSigned: Bool {
        return googleDriveService.hasSigned
    }

    func upload(presenting: PresentingConfiguration?) -> Observable<ProgressStatus> {
        return .create { observer in
            var disposables: [Disposable] = []

            /// 권한 부여 상태에 따라 `Google Drive` 에 업로드를 시작하고 경과에 따라 `observer` 에 적절한 Event 를 보냅니다.
            ///
            /// 권한이 있는 경우 즉시 `ProgressStatus.inProgress` 값을 가진 `Next Event` 를 생성하고 `Google Drive` 에 업로드를 시작합니다. 업로드가 성공하면 `ProgressStatus.complete` 값을 가진 `Next Event` 를 보내고 시퀀스가 종료됩니다.
            ///
            /// 권한이 없는 상태거나 업로드가 실패하면 이유에 맞는 `Error Event` 를 보내고 시퀀스가 종료됩니다.
            ///
            /// - Parameter authorizationStatus: 권한 부여 상태.
            func doUpload(authorizationStatus: SingleEvent<Void>) {
                switch authorizationStatus {
                case .success:
                    observer.onNext(.inProgress)

                    let wordListData: Data
                    do {
                        let wordList = self.wordService.fetchWordList()
                        wordListData = try JSONEncoder().encode(wordList)
                    } catch {
                        observer.onError(error)
                        return
                    }

                    let backupFile = BackupFile(name: .wordListBackup, data: wordListData)

                    let disposable = self.googleDriveService.deleteAllBackupFiles(named: backupFile.name)
                        .flatMap { self.googleDriveService.uploadBackupFile(backupFile) }
                        .subscribe(
                            onSuccess: { _ in
                                observer.onNext(.complete)
                                observer.onCompleted()
                            },
                            onFailure: { error in
                                observer.onError(error)
                            }
                        )
                    disposables.append(disposable)
                case .failure(let error):
                    observer.onError(error)
                }
            }

            if self.hasSigned, self.googleDriveService.isGrantedAppDataScope {
                doUpload(authorizationStatus: .success(()))
                return Disposables.create(disposables)
            }

            guard let presenting = presenting else {
                observer.onError(ExternalStoreUseCaseError.noPresentingConfiguration)
                return Disposables.create()
            }

            if self.hasSigned {
                let disposable = self.googleDriveService.requestAppDataScopeAccess(presenting: presenting)
                    .subscribe(doUpload(authorizationStatus:))
                disposables.append(disposable)
                return Disposables.create(disposables)
            }

            let disposable = self.signInWithAuthorization(presenting: presenting)
                .mapToVoid()
                .subscribe(doUpload(authorizationStatus:))
            disposables.append(disposable)
            return Disposables.create(disposables)
        }
    }

    func download(presenting: PresentingConfiguration?) -> Observable<ProgressStatus> {
        return .create { observer in
            var disposables: [Disposable] = []

            /// 권한 부여 상태에 따라 `Google Drive` 로부터 다운로드를 시작하고 경과에 따라 `observer` 에 적절한 Event 를 보냅니다.
            ///
            /// 권한이 있는 경우 즉시 `ProgressStatus.inProgress` 값을 가진 `Next Event` 를 생성하고 `Google Drive` 로부터 다운로드를 시작합니다. 다운로드가 성공하면 단어 목록을 동기화한 뒤, `ProgressStatus.complete` 값을 가진 `Next Event` 를 보내고 시퀀스가 종료됩니다.
            ///
            /// 권한이 없는 상태거나 다운로드가 실패하면 이유에 맞는 `Error Event` 를 보내고 시퀀스가 종료됩니다.
            ///
            /// - Parameter authorizationStatus: 권한 부여 상태.
            func doDownload(authorizationStatus: SingleEvent<Void>) {
                switch authorizationStatus {
                case .success:
                    observer.onNext(.inProgress)

                    let disposable = self.googleDriveService.downloadLatestBackupFile(backupFileName: BackupFileName.wordListBackup)
                        .map { backupFile -> [Word] in
                            return try JSONDecoder().decode([Word].self, from: backupFile.data)
                        }
                        .subscribe(on: ConcurrentMainScheduler.instance)
                        .observe(on: MainScheduler.instance)
                        .doOnSuccess { wordList in
                            try self.wordService.reset(to: wordList)
                            let memorizingList = wordList
                                .filter { $0.memorizationState == .memorizing }
                                .compactMap {
                                    do {
                                        return try MemorizingWord(id: $0.id, word: $0.word, isChecked: false)
                                    } catch {
                                        logger.warning("\(error)")
                                        return nil
                                    }
                                }
                            self.wordMemorizationService.setList(memorizingList)
                            self.updateDailyReminder()
                        }
                        .subscribe(
                            onSuccess: { _ in
                                observer.onNext(.complete)
                                observer.onCompleted()
                            },
                            onFailure: { error in
                                observer.onError(error)
                            }
                        )
                    disposables.append(disposable)
                case .failure(let error):
                    observer.onError(error)
                }
            }

            if self.hasSigned, self.googleDriveService.isGrantedAppDataScope {
                doDownload(authorizationStatus: .success(()))
                return Disposables.create(disposables)
            }

            guard let presenting = presenting else {
                observer.onError(ExternalStoreUseCaseError.noPresentingConfiguration)
                return Disposables.create(disposables)
            }

            if self.hasSigned {
                let disposable = self.googleDriveService.requestAppDataScopeAccess(presenting: presenting)
                    .subscribe(doDownload(authorizationStatus:))
                disposables.append(disposable)
                return Disposables.create(disposables)
            }

            let disposable = self.signInWithAuthorization(presenting: presenting)
                .mapToVoid()
                .subscribe(doDownload(authorizationStatus:))
            disposables.append(disposable)
            return Disposables.create(disposables)
        }
    }

    func restoreSignIn() -> Observable<Email?> {
        return googleDriveService.restorePreviousSignIn()
            .asObservable()
    }

    func syncWordList(using strategy: SyncStrategy) -> RxSwift.Single<Void> {
        fatalError()
    }
}

// MARK: Helpers

extension DefaultGoogleDriveUseCase {

    private func updateDailyReminder() {
        let unmemorizedWordCount = wordService.fetchUnmemorizedWordList().count

        Task {
            guard let dailyReminder = await self.localNotificationService.getPendingDailyReminder() else {
                return
            }

            let newDailyReminder = DailyReminder(
                unmemorizedWordCount: unmemorizedWordCount,
                noticeTime: dailyReminder.noticeTime
            )
            try await self.localNotificationService.setDailyReminder(newDailyReminder)
        }
    }
}
