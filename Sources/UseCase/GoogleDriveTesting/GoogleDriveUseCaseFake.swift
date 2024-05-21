//
//  ExternalStoreUseCaseFake.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/10/03.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain_Core
import Domain_GoogleDrive
import Foundation
import RxSwift
import UseCase_GoogleDrive

public final class GoogleDriveUseCaseFake: GoogleDriveUseCase {

    let scheduler: SchedulerType

    public var _hasSigned: Bool = false
    public var willAlwaysFailUploading: Bool = false
    public var willAlwaysFailDownloading: Bool = false
    private let testEmail = "Lorem-ipsum@gmail.com"

    public init(scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .userInitiated)) {
        self.scheduler = scheduler
    }

    public func signInWithAuthorization(presenting: Domain_GoogleDrive.PresentingConfiguration) -> RxSwift.Single<Domain_GoogleDrive.Email?> {
        _hasSigned = true
        return .just(testEmail)
    }
    
    public var currentUserEmail: Domain_GoogleDrive.Email? {
        testEmail
    }
    
    public func restoreSignIn() -> RxSwift.Observable<Domain_GoogleDrive.Email?> {
        _hasSigned = true
        return .just(testEmail)
    }
    
    public func signOut() {
        _hasSigned = false
    }

    public var hasSigned: Bool {
        _hasSigned
    }

    public func upload(presenting: PresentingConfiguration?) -> RxSwift.Observable<ProgressStatus> {
        if willAlwaysFailUploading {
            return .error(GoogleDriveUseCaseFakeError.fakeError)
        }
        
        func doUpload() -> Observable<ProgressStatus> {
            return .create { observer in
                observer.onNext(.inProgress)

                sleep(1)

                observer.onNext(.complete)
                observer.onCompleted()

                return Disposables.create()
            }
            .subscribe(on: scheduler)
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

    public func download(presenting: PresentingConfiguration?) -> RxSwift.Observable<ProgressStatus> {
        if willAlwaysFailDownloading {
            return .error(GoogleDriveUseCaseFakeError.fakeError)
        }
        
        func doDownload() -> Observable<ProgressStatus> {
            return .create { observer in
                observer.onNext(.inProgress)

                sleep(1)

                observer.onNext(.complete)
                observer.onCompleted()

                return Disposables.create()
            }
            .subscribe(on: scheduler)
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

    public func syncWordList(using strategy: SyncStrategy) -> RxSwift.Single<Void> {
        fatalError()
    }
}

enum GoogleDriveUseCaseFakeError: Error {

    case noPresentingConfiguration
    
    case fakeError

}
