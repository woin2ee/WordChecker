//
//  WordCheckingReactorTests.swift
//  DomainUnitTests
//
//  Created by Jaewon Yun on 11/22/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain_LocalNotificationTesting
import Domain_WordManagementTesting
@testable import Domain_WordMemorization
import Domain_WordMemorizationTesting
@testable import IOSScene_WordChecking
import IOSSupport
@testable import UseCase_Word
@testable import UseCase_WordTesting
import UseCase_UserSettingsTesting

import XCTest

final class WordCheckingReactorTests: XCTestCase {

    var sut: WordCheckingReactor!

    override func setUpWithError() throws {
        sut = WordCheckingReactor(
            wordUseCase: DefaultWordUseCase(
                wordManagementService: FakeWordManagementService(),
                wordMemorizationService: FakeWordMemorizationService(),
                localNotificationService: LocalNotificationServiceFake()
            ),
            userSettingsUseCase: UserSettingsUseCaseFake(),
            globalAction: GlobalAction.shared,
            globalState: GlobalState.shared
        )
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_firstAddWord() {
        // When
        sut.action.onNext(.addWord("Test"))

        // Then
        XCTAssertEqual(sut.currentState.currentWord?.word, "Test")
    }

    func test_deleteLastWord() {
        // Given
        sut.action.onNext(.addWord("Test"))

        // When
        sut.action.onNext(.deleteCurrentWord)

        // Then
        XCTAssertNil(sut.currentState.currentWord)
    }

    func test_markAsMemorizedLastWord() {
        // Given
        sut.action.onNext(.addWord("Test"))

        // When
        sut.action.onNext(.markCurrentWordAsMemorized)

        // Then
        XCTAssertNil(sut.currentState.currentWord)
    }

    func test_addDuplicatedWord() {
        // Given
        sut.action.onNext(.addWord("testWord"))

        // When
        sut.action.onNext(.addWord("TESTWORD"))

        // Then
        XCTAssertNotNil(sut.currentState.showAddCompleteToast)
    }

    func test_initialFontSize() {
        // Given
        let wordUseCase = DefaultWordUseCase(
            wordManagementService: FakeWordManagementService(),
            wordMemorizationService: FakeWordMemorizationService(),
            localNotificationService: LocalNotificationServiceFake()
        )
        let userSettingsUseCase = UserSettingsUseCaseFake()
        userSettingsUseCase.currentUserSettings.memorizingWordSize = .veryLarge
        sut = .init(
            wordUseCase: wordUseCase,
            userSettingsUseCase: userSettingsUseCase,
            globalAction: .shared,
            globalState: GlobalState.shared
        )
        
        // When
        sut.action.onNext(.viewDidLoad)
        
        // Then
        XCTAssertEqual(sut.currentState.fontSize, .veryLarge)
    }
}
