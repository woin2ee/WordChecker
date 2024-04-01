//
//  WordCheckingReactorTests.swift
//  DomainUnitTests
//
//  Created by Jaewon Yun on 11/22/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import IOSScene_WordChecking
import UseCase_WordTesting
import UseCase_UserSettingsTesting

import XCTest

final class WordCheckingReactorTests: XCTestCase {

    var sut: WordCheckingReactor!

    override func setUpWithError() throws {
        try super.setUpWithError()

        let wordUseCase: WordUseCaseFake = .init()
        let userSettingsUseCase: UserSettingsUseCaseFake = .init()

        sut = .init(
            wordUseCase: wordUseCase,
            userSettingsUseCase: userSettingsUseCase,
            globalAction: .shared
        )
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

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

}
