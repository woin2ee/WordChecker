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

public final class GoogleDriveUseCase: ExternalStoreUseCaseProtocol {

    let wordRepository: WordRepositoryProtocol
    let googleDriveRepository: GoogleDriveRepositoryProtocol
    let unmemorizedWordListRepository: UnmemorizedWordListRepositoryProtocol
    let userSettingsUseCase: UserSettingsUseCaseProtocol

    public init(
        wordRepository: WordRepositoryProtocol,
        googleDriveRepository: GoogleDriveRepositoryProtocol,
        unmemorizedWordListRepository: UnmemorizedWordListRepositoryProtocol,
        userSettingsUseCase: UserSettingsUseCaseProtocol
    ) {
        self.wordRepository = wordRepository
        self.googleDriveRepository = googleDriveRepository
        self.unmemorizedWordListRepository = unmemorizedWordListRepository
        self.userSettingsUseCase = userSettingsUseCase
    }

    public func signInWithAuthorization(presenting: PresentingConfiguration) -> RxSwift.Single<Void> {
        if hasSigned, googleDriveRepository.isGrantedAppDataScope {
            return .just(())
        }

        return googleDriveRepository.restorePreviousSignIn()
            .flatMap { self.googleDriveRepository.requestAccess(presenting: presenting) }
            .catch { _ in self.googleDriveRepository.signInWithAppDataScope(presenting: presenting) }
    }

    public func signOut() {
        googleDriveRepository.signOut()
    }

    public var hasSigned: Bool {
        return googleDriveRepository.hasSigned
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

                    let wordList = self.wordRepository.getAll()

                    let disposable = self.googleDriveRepository.uploadWordList(wordList)
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

            if self.hasSigned, self.googleDriveRepository.isGrantedAppDataScope {
                doUpload(authorizationStatus: .success(()))
                return Disposables.create(disposables)
            }

            guard let presenting = presenting else {
                observer.onError(ExternalStoreUseCaseError.noPresentingConfiguration)
                return Disposables.create()
            }

            if self.hasSigned {
                let disposable = self.googleDriveRepository.requestAccess(presenting: presenting)
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

                    let disposable = self.googleDriveRepository.downloadWordList()
                        .observe(on: MainScheduler.instance)
                        .doOnSuccess { wordList in
                            self.wordRepository.reset(to: wordList)
                            let unmemorizedList = self.wordRepository.getUnmemorizedList()
                            self.unmemorizedWordListRepository.shuffle(with: unmemorizedList)
                            _ = self.userSettingsUseCase.resetDailyReminder()
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

            if self.hasSigned, self.googleDriveRepository.isGrantedAppDataScope {
                doDownload(authorizationStatus: .success(()))
                return Disposables.create(disposables)
            }

            guard let presenting = presenting else {
                observer.onError(ExternalStoreUseCaseError.noPresentingConfiguration)
                return Disposables.create(disposables)
            }

            if self.hasSigned {
                let disposable = self.googleDriveRepository.requestAccess(presenting: presenting)
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
        return googleDriveRepository.restorePreviousSignIn()
            .asObservable()
    }

}

enum ExternalStoreUseCaseError: Error {

    case noCurrentUser

    case noPresentingConfiguration

}
