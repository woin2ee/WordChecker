//
//  ExternalStoreUseCaseFake.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/10/03.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import RxSwift

public final class GoogleDriveUseCaseFake: ExternalStoreUseCaseProtocol {

    public var _hasSigned: Bool = false

    public init() {}

    public func signInWithAuthorization(presenting: Domain.PresentingConfiguration) -> RxSwift.Single<Void> {
        _hasSigned = true
        return .just(())
    }

    public func signOut() {
        _hasSigned = false
    }

    public var hasSigned: Bool {
        _hasSigned
    }

    public func upload(presenting: Domain.PresentingConfiguration?) -> RxSwift.Observable<Domain.ProgressStatus> {
        func doUpload() -> Observable<Domain.ProgressStatus> {
            return .create { observer in
                observer.onNext(.inProgress)

                sleep(1)

                observer.onNext(.complete)
                observer.onCompleted()

                return Disposables.create()
            }
        }

        if _hasSigned {
            return doUpload()
        }

        guard presenting != nil else {
            return .error(GoogleDriveUseCaseFakeError.noPresentingConfiguration)
        }

        _hasSigned = true
        return doUpload()
    }

    public func download(presenting: Domain.PresentingConfiguration?) -> RxSwift.Observable<Domain.ProgressStatus> {
        func doDownload() -> Observable<ProgressStatus> {
            return .create { observer in
                observer.onNext(.inProgress)

                sleep(1)

                observer.onNext(.complete)
                observer.onCompleted()

                return Disposables.create()
            }
        }

        if _hasSigned {
            return doDownload()
        }

        guard presenting != nil else {
            return .error(GoogleDriveUseCaseFakeError.noPresentingConfiguration)
        }

        _hasSigned = true
        return doDownload()
    }

    public func restoreSignIn() -> RxSwift.Observable<Void> {
        _hasSigned = true
        return .just(())
    }

}

enum GoogleDriveUseCaseFakeError: Error {

    case noPresentingConfiguration

}
