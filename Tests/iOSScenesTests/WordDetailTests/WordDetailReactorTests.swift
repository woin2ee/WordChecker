//
//  WordDetailReactorTests.swift
//  WordDetailTests
//
//  Created by Jaewon Yun on 2/13/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

@testable import WordDetail

import Domain
import DomainTesting
import XCTest

final class WordDetailReactorTests: XCTestCase {

    var sut: WordDetailReactor!

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func test_enteredWordIsDuplicated() {
        // Given
        let uuid1: UUID = .init()
        let word1: Word = .init(uuid: uuid1, word: "Word1")

        let uuid2: UUID = .init()
        let word2: Word = .init(uuid: uuid2, word: "Word2")

        let wordUseCase = WordUseCaseFake()
        wordUseCase._wordList = [word1, word2]

        sut = .init(uuid: word1.uuid, globalAction: .shared, wordUseCase: wordUseCase)
        sut.action.onNext(.viewDidLoad)

        // When
        sut.action.onNext(.enteredWord("Word2"))

        // Then
        XCTAssertTrue(sut.currentState.enteredWordIsDuplicated)
    }

    func test_enteredWordIsDuplicated_whenSameOriginWord() {
        // Given
        let uuid1: UUID = .init()
        let word1: Word = .init(uuid: uuid1, word: "Word1")

        let wordUseCase = WordUseCaseFake()
        wordUseCase._wordList = [word1]

        sut = .init(uuid: word1.uuid, globalAction: .shared, wordUseCase: wordUseCase)
        sut.action.onNext(.viewDidLoad)

        // When
        sut.action.onNext(.enteredWord("Word1"))

        // Then
        XCTAssertFalse(sut.currentState.enteredWordIsDuplicated)
    }

    func test_enteredWordIsEmpty() {
        // Given
        let uuid1: UUID = .init()
        let word1: Word = .init(uuid: uuid1, word: "Word1")

        let wordUseCase = WordUseCaseFake()
        wordUseCase._wordList = [word1]

        sut = .init(uuid: word1.uuid, globalAction: .shared, wordUseCase: wordUseCase)
        sut.action.onNext(.viewDidLoad)

        // When
        sut.action.onNext(.enteredWord(""))

        // Then
        XCTAssertTrue(sut.currentState.enteredWordIsEmpty)
    }

}
