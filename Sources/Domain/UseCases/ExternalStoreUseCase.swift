//
//  GoogleDriveUseCase.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/22.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import RxSwift
import RxUtility

public final class ExternalStoreUseCase: ExternalStoreUseCaseProtocol {

    let wordRepository: WordRepositoryProtocol
    let unmemorizedWordListRepository: UnmemorizedWordListRepositoryProtocol

    let googleDriveService: GoogleDriveService

    let notificationsUseCase: NotificationsUseCaseProtocol

    init(wordRepository: WordRepositoryProtocol, unmemorizedWordListRepository: UnmemorizedWordListRepositoryProtocol, googleDriveService: GoogleDriveService, notificationsUseCase: NotificationsUseCaseProtocol) {
        self.wordRepository = wordRepository
        self.unmemorizedWordListRepository = unmemorizedWordListRepository
        self.googleDriveService = googleDriveService
        self.notificationsUseCase = notificationsUseCase
    }

    public func signInWithAuthorization(presenting: PresentingConfiguration) -> RxSwift.Single<Void> {
        if hasSigned, googleDriveService.isGrantedAppDataScope {
            return .just(())
        }

        return googleDriveService.restorePreviousSignIn()
            .flatMap { self.googleDriveService.requestAppDataScopeAccess(presenting: presenting) }
            .catch { _ in self.googleDriveService.signInWithAppDataScope(presenting: presenting) }
    }

    public func signOut() {
        googleDriveService.signOut()
    }

    public var hasSigned: Bool {
        return googleDriveService.hasSigned
    }

    public func upload(presenting: PresentingConfiguration?) -> Observable<ProgressStatus> {
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

                    let wordList = self.wordRepository.getAllWords()

                    let disposable = self.googleDriveService.uploadWordList(wordList)
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
                .subscribe(doUpload(authorizationStatus:))
            disposables.append(disposable)
            return Disposables.create(disposables)
        }
    }

    public func download(presenting: PresentingConfiguration?) -> Observable<ProgressStatus> {
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

                    let disposable = self.googleDriveService.downloadWordList()
                        .observe(on: MainScheduler.instance)
                        .doOnSuccess { wordList in
                            self.wordRepository.reset(to: wordList)
                            let unmemorizedList = self.wordRepository.getUnmemorizedList()
                            self.unmemorizedWordListRepository.shuffle(with: unmemorizedList)
                            _ = self.notificationsUseCase.updateDailyReminder()
                                        .subscribe()
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
                .subscribe(doDownload(authorizationStatus:))
            disposables.append(disposable)
            return Disposables.create(disposables)
        }
    }

    public func restoreSignIn() -> Observable<Void> {
        return googleDriveService.restorePreviousSignIn()
            .asObservable()
    }

}

enum ExternalStoreUseCaseError: Error {

    case noCurrentUser

    case noPresentingConfiguration

}
