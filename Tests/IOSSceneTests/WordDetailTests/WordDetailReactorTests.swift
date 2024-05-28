//
//  WordDetailReactorTests.swift
//  WordDetailTests
//
//  Created by Jaewon Yun on 2/13/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

@testable import IOSScene_WordDetail
import Domain_WordManagement
import IOSSupport
import RxBlocking
import UseCase_WordTesting
import XCTest

final class WordDetailReactorTests: XCTestCase {

    var sut: WordDetailReactor!

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_enteredWordIsDuplicated() throws {
        // Given
        let wordUseCase = FakeWordUseCase()
        try wordUseCase.addNewWord("Word1").toBlocking().single()
        try wordUseCase.addNewWord("Word2").toBlocking().single()
        
        let word1 = wordUseCase.fetchWordList().first(where: { $0.word == "Word1" })!

        sut = .init(uuid: word1.uuid, globalAction: GlobalAction.shared, wordUseCase: wordUseCase)
        sut.action.onNext(.viewDidLoad)

        // When
        sut.action.onNext(.enteredWord("Word2"))

        // Then
        XCTAssertTrue(sut.currentState.enteredWordIsDuplicated)
    }

    func test_enteredWordIsDuplicated_whenSameOriginWord() throws {
        // Given
        let wordUseCase = FakeWordUseCase()
        try wordUseCase.addNewWord("Word1").toBlocking().single()
        let word1 = wordUseCase.fetchWordList().first(where: { $0.word == "Word1" })!

        sut = .init(uuid: word1.uuid, globalAction: GlobalAction.shared, wordUseCase: wordUseCase)
        sut.action.onNext(.viewDidLoad)

        // When
        sut.action.onNext(.enteredWord("Word1"))

        // Then
        XCTAssertFalse(sut.currentState.enteredWordIsDuplicated)
    }

    func test_enteredWordIsEmpty() throws {
        // Given
        let wordUseCase = FakeWordUseCase()
        try wordUseCase.addNewWord("Word1").toBlocking().single()
        let word1 = wordUseCase.fetchWordList().first(where: { $0.word == "Word1" })!

        sut = .init(uuid: word1.uuid, globalAction: GlobalAction.shared, wordUseCase: wordUseCase)
        sut.action.onNext(.viewDidLoad)

        // When
        sut.action.onNext(.enteredWord(""))

        // Then
        XCTAssertTrue(sut.currentState.enteredWordIsEmpty)
    }

}
