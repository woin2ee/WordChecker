//
//  WordListReactorTests.swift
//  iOSCoreUnitTests
//
//  Created by Jaewon Yun on 2023/11/12.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import IOSScene_WordList
@testable import Domain_LocalNotificationTesting
@testable import Domain_Word
@testable import Domain_WordTesting
@testable import UseCase_Word
import IOSSupport

import RxBlocking
import XCTest

final class WordListReactorTests: XCTestCase {

    var sut: WordListReactor!

    override func setUpWithError() throws {
        // Prepare word list (memorizing: 2개, memorized: 3개)
        let wordRepositoryFake = WordRepositoryFake()
        wordRepositoryFake.save(try Word(word: "1"))
        wordRepositoryFake.save(try Word(word: "2"))
        wordRepositoryFake.save(try Word(word: "A", memorizationState: .memorized))
        wordRepositoryFake.save(try Word(word: "B", memorizationState: .memorized))
        wordRepositoryFake.save(try Word(word: "C", memorizationState: .memorized))
        
        let wordUseCase = DefaultWordUseCase(
            wordService: DefaultWordService(
                wordRepository: wordRepositoryFake,
                unmemorizedWordListRepository: UnmemorizedWordListRepository(),
                wordDuplicateSpecification: WordDuplicateSpecification(wordRepository: wordRepositoryFake)
            ),
            localNotificationService: LocalNotificationServiceDummy()
        )

        sut = .init(globalAction: GlobalAction.shared, wordUseCase: wordUseCase)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testShowAllWordListFirst() throws {
        // Arrange
        XCTAssertEqual(sut.currentState.wordList, [])

        // Act
        sut.action.onNext(.viewDidLoad)

        // Assert
        XCTAssertEqual(sut.currentState.wordList.count, 2 + 3)
    }

    func testShowMemorizedList() {
        // Arrange
        sut.action.onNext(.viewDidLoad)

        // Act
        sut.action.onNext(.refreshWordList(.memorized))

        // Assert
        XCTAssertEqual(sut.currentState.wordList.count, 3)
    }

    func testShowUnmemorizedList() {
        // Arrange
        sut.action.onNext(.viewDidLoad)

        // Act
        sut.action.onNext(.refreshWordList(.memorizing))

        // Assert
        XCTAssertEqual(sut.currentState.wordList.count, 2)
    }

    func testEditUnmemorizedWordWhenShowUnmemorized() {
        // Arrange
        sut.action.onNext(.refreshWordList(.memorizing))

        let index = 1

        XCTAssertFalse(sut.currentState.wordList.contains(where: { $0.word == "UnmemorizedWord" }))

        // Act
        sut.action.onNext(.editWord("UnmemorizedWord", index))

        // Assert
        XCTAssertTrue(sut.currentState.wordList.contains(where: { $0.word == "UnmemorizedWord" }))
    }

    func testDeleteMemorizedWordWhenShowAll() {
        // Arrange
        sut.action.onNext(.refreshWordList(.all))

        let index = sut.currentState.wordList.lastIndex(where: { $0.memorizationState == .memorized })!

        let deletedWord = sut.currentState.wordList[index].word

        // Act
        sut.action.onNext(.deleteWord(index))

        // Assert
        XCTAssertFalse(sut.currentState.wordList.contains(where: { $0.word == deletedWord }))
        sut.action.onNext(.refreshWordList(.memorized))
        XCTAssertFalse(sut.currentState.wordList.contains(where: { $0.word == deletedWord }))
    }

    func testDeleteUnmemorizedWordWhenShowAll() {
        // Arrange
        sut.action.onNext(.refreshWordList(.all))

        let index = sut.currentState.wordList.lastIndex(where: { $0.memorizationState == .memorizing })!

        let deletedWord = sut.currentState.wordList[index].word

        // Act
        sut.action.onNext(.deleteWord(index))

        // Assert
        XCTAssertFalse(sut.currentState.wordList.contains(where: { $0.word == deletedWord }))
        sut.action.onNext(.refreshWordList(.memorizing))
        XCTAssertFalse(sut.currentState.wordList.contains(where: { $0.word == deletedWord }))
    }

}
