//
//  UserSettingsReactorTests.swift
//  DomainTests
//
//  Created by Jaewon Yun on 11/27/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import IOSScene_UserSettings
import Domain_GoogleDrive
import IOSSupport
import UseCase_GoogleDriveTesting
import UseCase_UserSettingsTesting

import ReactorKit
import RxTest
import TestsSupport
import XCTest

final class UserSettingsReactorTests: RxBaseTestCase {

    var sut: UserSettingsReactor!

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = .init(
            userSettingsUseCase: UserSettingsUseCaseFake(),
            googleDriveUseCase: GoogleDriveUseCaseFake(scheduler: testScheduler),
            globalAction: GlobalAction.shared
        )
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
    }

    func test_uploadWhenNotSignedIn() {
        // Given
        let presentingWindow: PresentingConfiguration = .init(window: UIViewController())

        // When
        testScheduler
            .createHotObservable([
                .next(210, .uploadData(presentingWindow))
            ])
            .subscribe(sut.action)
            .disposed(by: disposeBag)

        // Then
        let result = testScheduler.start {
            self.sut.state.map(\.uploadStatus)
        }
        XCTAssertEqual(result.events.map(\.value.element), [
            .noTask, // initialState
            .noTask, // due to commit signIn mutation
            .inProgress,
            .complete,
            .complete, // due to commit `showUploadSuccessAlert` mutation
        ])
        XCTAssertEqual(sut.currentState.hasSigned, true)
    }

    func test_downloadWhenSignedIn() {
        // Given
        let presentingWindow: PresentingConfiguration = .init(window: UIViewController())
        sut.initialState = .init(
            sourceLanguage: .english,
            targetLanguage: .korean,
            signState: .signed(email: ""),
            uploadStatus: .noTask,
            downloadStatus: .noTask
        )

        // When
        testScheduler
            .createHotObservable([
                .next(210, .downloadData(presentingWindow))
            ])
            .subscribe(sut.action)
            .disposed(by: disposeBag)

        // Then
        let result = testScheduler.start {
            self.sut.state.map(\.downloadStatus)
        }
        XCTAssertEqual(result.events.map(\.value.element), [
            .noTask, // initialState
            .inProgress,
            .complete,
            .complete, // due to commit `showDownloadSuccessAlert` mutation
        ])
    }

    func test_signOut() {
        // Given
        sut.initialState = .init(
            sourceLanguage: .english,
            targetLanguage: .korean,
            signState: .signed(email: "Test@gmail.com"),
            uploadStatus: .noTask,
            downloadStatus: .noTask
        )

        // When
        sut.action.onNext(.signOut)

        // Then
        XCTAssertEqual(sut.currentState.hasSigned, false)
        XCTAssertEqual(sut.currentState.signState, .unsigned)
    }

    func test_viewDidLoad() {
        // Given
        let userSettingsUseCase: UserSettingsUseCaseFake = .init()
        userSettingsUseCase.currentUserSettings = .init(translationSourceLocale: .german, translationTargetLocale: .italian, hapticsIsOn: true, themeStyle: .system)
        sut = .init(
            userSettingsUseCase: userSettingsUseCase,
            googleDriveUseCase: GoogleDriveUseCaseFake(scheduler: testScheduler),
            globalAction: .shared
        )

        // When
        sut.action.onNext(.viewDidLoad)

        // Then
        XCTAssertEqual(sut.currentState.sourceLanguage, .german)
        XCTAssertEqual(sut.currentState.targetLanguage, .italian)
    }

    func test_showUploadAlert_whenSuccess() {
        // Given
        let googleDriveUseCase = GoogleDriveUseCaseFake(scheduler: testScheduler)
        
        sut = UserSettingsReactor(
            userSettingsUseCase: UserSettingsUseCaseFake(),
            googleDriveUseCase: googleDriveUseCase,
            globalAction: GlobalAction.shared
        )
        
        let presentingWindow: PresentingConfiguration = .init(window: UIViewController())
        
        testScheduler
            .createTrigger()
            .map { UserSettingsReactor.Action.uploadData(presentingWindow) }
            .bind(to: sut.action)
            .disposed(by: disposeBag)
        
        // When
        let result = testScheduler.start {
            self.sut.pulse(\.$showUploadSuccessAlert)
                .unwrapOrIgnore()
        }
        
        // Then
        XCTAssertRecordedElements(result.events, [()])
    }
    
    func test_showUploadAlert_whenFailed() {
        // Given
        let googleDriveUseCase = GoogleDriveUseCaseFake(scheduler: testScheduler)
        googleDriveUseCase.willAlwaysFailUploading = true
        
        sut = UserSettingsReactor(
            userSettingsUseCase: UserSettingsUseCaseFake(),
            googleDriveUseCase: googleDriveUseCase,
            globalAction: GlobalAction.shared
        )
        
        let presentingWindow: PresentingConfiguration = .init(window: UIViewController())
        
        testScheduler
            .createTrigger()
            .map { UserSettingsReactor.Action.uploadData(presentingWindow) }
            .bind(to: sut.action)
            .disposed(by: disposeBag)
        
        // When
        let result = testScheduler.start {
            self.sut.pulse(\.$showUploadFailureAlert)
                .unwrapOrIgnore()
        }
        
        // Then
        XCTAssertRecordedElements(result.events, [()])
    }
    
    func test_showDownloadAlert_whenSuccess() {
        // Given
        let googleDriveUseCase = GoogleDriveUseCaseFake(scheduler: testScheduler)
        
        sut = UserSettingsReactor(
            userSettingsUseCase: UserSettingsUseCaseFake(),
            googleDriveUseCase: googleDriveUseCase,
            globalAction: GlobalAction.shared
        )
        
        let presentingWindow: PresentingConfiguration = .init(window: UIViewController())
        
        testScheduler
            .createTrigger()
            .map { UserSettingsReactor.Action.downloadData(presentingWindow) }
            .bind(to: sut.action)
            .disposed(by: disposeBag)
        
        // When
        let result = testScheduler.start {
            self.sut.pulse(\.$showDownloadSuccessAlert)
                .unwrapOrIgnore()
        }
        
        // Then
        XCTAssertRecordedElements(result.events, [()])
    }
    
    func test_showDownloadAlert_whenFailed() {
        // Given
        let googleDriveUseCase = GoogleDriveUseCaseFake(scheduler: testScheduler)
        googleDriveUseCase.willAlwaysFailDownloading = true
        
        sut = UserSettingsReactor(
            userSettingsUseCase: UserSettingsUseCaseFake(),
            googleDriveUseCase: googleDriveUseCase,
            globalAction: GlobalAction.shared
        )
        
        let presentingWindow: PresentingConfiguration = .init(window: UIViewController())
        
        testScheduler
            .createTrigger()
            .map { UserSettingsReactor.Action.downloadData(presentingWindow) }
            .bind(to: sut.action)
            .disposed(by: disposeBag)
        
        // When
        let result = testScheduler.start {
            self.sut.pulse(\.$showDownloadFailureAlert)
                .unwrapOrIgnore()
        }
        
        // Then
        XCTAssertRecordedElements(result.events, [()])
    }
}

// MARK: Templates
// func test_() {
//    // Given
//
//
//    // When
//
//
//    // Then
//
// }
