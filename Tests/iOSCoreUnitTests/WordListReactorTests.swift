//
//  WordListReactorTests.swift
//  iOSCoreUnitTests
//
//  Created by Jaewon Yun on 2023/11/12.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import iOSCore
import Domain
import RxBlocking
import Testing
import XCTest

final class WordListReactorTests: XCTestCase {

    var sut: WordListReactor!

    override func setUpWithError() throws {
        try super.setUpWithError()

        let wordUseCase: WordRxUseCaseFake = .init()

        // Prepare word list (memorizing: 2개, memorized: 3개)
        try wordUseCase.addNewWord(.init(word: "1")).toBlocking().single()
        try wordUseCase.addNewWord(.init(word: "2")).toBlocking().single()
        try wordUseCase.addNewWord(.init(word: "A", memorizedState: .memorized)).toBlocking().single()
        try wordUseCase.addNewWord(.init(word: "B", memorizedState: .memorized)).toBlocking().single()
        try wordUseCase.addNewWord(.init(word: "C", memorizedState: .memorized)).toBlocking().single()

        sut = .init(globalAction: .shared, wordUseCase: wordUseCase)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

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
        sut.action.onNext(.refreshWordList(.unmemorized))

        // Assert
        XCTAssertEqual(sut.currentState.wordList.count, 2)
    }

    func testEditUnmemorizedWordWhenShowUnmemorized() {
        // Arrange
        sut.action.onNext(.refreshWordList(.unmemorized))

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

        let index = sut.currentState.wordList.lastIndex(where: { $0.memorizedState == .memorized })!

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

        let index = sut.currentState.wordList.lastIndex(where: { $0.memorizedState == .memorizing })!

        let deletedWord = sut.currentState.wordList[index].word

        // Act
        sut.action.onNext(.deleteWord(index))

        // Assert
        XCTAssertFalse(sut.currentState.wordList.contains(where: { $0.word == deletedWord }))
        sut.action.onNext(.refreshWordList(.unmemorized))
        XCTAssertFalse(sut.currentState.wordList.contains(where: { $0.word == deletedWord }))
    }

}
