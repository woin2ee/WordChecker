//
//  ExternalStoreUseCaseFake.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/10/03.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain_Core
import Domain_GoogleDrive
import Domain_GoogleDriveTesting
import Domain_LocalNotification
import Domain_LocalNotificationTesting
import Domain_WordManagement
import Domain_WordManagementTesting
import Domain_WordMemorization
import Domain_WordMemorizationTesting
import Foundation
import RxSwift
@testable import UseCase_GoogleDrive

public final class GoogleDriveUseCaseFake: GoogleDriveUseCase {

    private let _googleDriveUseCase: GoogleDriveUseCase
    
    let scheduler: SchedulerType

    public var willAlwaysFailUploading: Bool = false
    public var willAlwaysFailDownloading: Bool = false

    public init(
        scheduler: SchedulerType = ConcurrentMainScheduler.instance,
        googleDriveService: GoogleDriveService = GoogleDriveServiceFake(),
        wordService: WordManagementService = FakeWordManagementService(),
        wordMemorizationService: WordMemorizationService = FakeWordMemorizationService.fake(),
        localNotificationService: LocalNotificationService = LocalNotificationServiceFake()
    ) {
        self.scheduler = scheduler
        self._googleDriveUseCase = DefaultGoogleDriveUseCase(
            googleDriveService: googleDriveService,
            wordService: wordService,
            wordMemorizationService: wordMemorizationService,
            localNotificationService: localNotificationService
        )
    }

    public func signInWithAuthorization(presenting: Domain_GoogleDrive.PresentingConfiguration) -> RxSwift.Single<Domain_GoogleDrive.Email?> {
        _googleDriveUseCase.signInWithAuthorization(presenting: presenting)
    }
    
    public var currentUserEmail: Domain_GoogleDrive.Email? {
        _googleDriveUseCase.currentUserEmail
    }
    
    public func restoreSignIn() -> RxSwift.Observable<Domain_GoogleDrive.Email?> {
        _googleDriveUseCase.restoreSignIn()
    }
    
    public func signOut() {
        _googleDriveUseCase.signOut()
    }

    public var hasSigned: Bool {
        _googleDriveUseCase.hasSigned
    }

    public func upload(presenting: PresentingConfiguration?) -> RxSwift.Observable<ProgressStatus> {
        if willAlwaysFailUploading {
            return .error(GoogleDriveUseCaseFakeError.fakeError)
        }
        
        return _googleDriveUseCase.upload(presenting: presenting)
            .subscribe(on: scheduler)
    }

    public func download(presenting: PresentingConfiguration?) -> RxSwift.Observable<ProgressStatus> {
        if willAlwaysFailDownloading {
            return .error(GoogleDriveUseCaseFakeError.fakeError)
        }
        
        return _googleDriveUseCase.download(presenting: presenting)
            .subscribe(on: scheduler)
    }

    public func syncWordList(using strategy: SyncStrategy) -> RxSwift.Single<Void> {
        _googleDriveUseCase.syncWordList(using: strategy)
    }
}

enum GoogleDriveUseCaseFakeError: Error {

    case noPresentingConfiguration
    
    case fakeError

}
