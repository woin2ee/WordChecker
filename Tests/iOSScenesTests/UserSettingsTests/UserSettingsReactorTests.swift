//
//  UserSettingsReactorTests.swift
//  DomainTests
//
//  Created by Jaewon Yun on 11/27/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import UserSettings

import Domain
import DomainTesting
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
            globalAction: .shared
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
        ])
        XCTAssertEqual(sut.currentState.hasSigned, true)
    }

    func test_downloadWhenSignedIn() {
        // Given
        let presentingWindow: PresentingConfiguration = .init(window: UIViewController())
        sut.initialState = .init(
            sourceLanguage: .english,
            targetLanguage: .korean,
            hasSigned: true,
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
        ])
    }

    func test_signOut() {
        // Given
        sut.initialState = .init(
            sourceLanguage: .english,
            targetLanguage: .korean,
            hasSigned: true,
            uploadStatus: .noTask,
            downloadStatus: .noTask
        )

        // When
        sut.action.onNext(.signOut)

        // Then
        XCTAssertEqual(sut.currentState.hasSigned, false)
    }

    func test_viewDidLoad() {
        // Given
        let userSettingsUseCase: UserSettingsUseCaseFake = .init()
        userSettingsUseCase.currentUserSettings = .init(translationSourceLocale: .german, translationTargetLocale: .italian, hapticsIsOn: true)
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
