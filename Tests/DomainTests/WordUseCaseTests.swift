//
//  WordUseCaseTests.swift
//  WordUseCaseTests
//
//  Created by Jaewon Yun on 2023/09/04.
//

@testable import Domain
@testable import Utility

import DataDriverTesting
import XCTest

final class WordUseCaseTests: XCTestCase {

    var sut: WordUseCaseProtocol!

    let memorizedWordList: [Word] = [
        .init(word: "F", memorizedState: .memorized),
        .init(word: "G", memorizedState: .memorized),
        .init(word: "H", memorizedState: .memorized),
        .init(word: "I", memorizedState: .memorized),
        .init(word: "J", memorizedState: .memorized),
    ]

    let unmemorizedWordList: [Word] = [
        .init(word: "A"),
        .init(word: "B"),
        .init(word: "C"),
        .init(word: "D"),
        .init(word: "E"),
    ]

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = WordUseCase.init(
            wordRepository: makePreparedWordRepository(),
            unmemorizedWordListRepository: makePreparedUnmemorizedWordListRepository()
        )
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
    }

    func test_addNewWord() {
        // Arrange
        guard let testUUID: UUID = .init(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F") else {
            return XCTFail("Failed to initialize uuid.")
        }
        let testWord: Word = .init(uuid: testUUID, word: "Test", memorizedState: .memorizing)

        // Act
        sut.addNewWord(testWord)

        // Assert
        XCTAssertEqual(sut.getWord(by: testUUID), testWord)
    }

    func test_deleteUnmemorizedWord() {
        // Arrange
        guard let deleteTarget: Word = unmemorizedWordList.last else {
            return XCTFail("'unmemorizedWordList' property is empty.")
        }

        // Act
        sut.deleteWord(by: deleteTarget.uuid)

        // Assert
        XCTAssertNil(sut.getWord(by: deleteTarget.uuid))
        XCTAssertFalse(sut.getUnmemorizedWordList().contains(where: { $0.uuid == deleteTarget.uuid }))
    }

    func test_deleteMemorizedWord() {
        // Arrange
        guard let deleteTarget: Word = memorizedWordList.last else {
            return XCTFail("'memorizedWordList' property is empty.")
        }

        // Act
        sut.deleteWord(by: deleteTarget.uuid)

        // Assert
        XCTAssertNil(sut.getWord(by: deleteTarget.uuid))
        XCTAssertFalse(sut.getMemorizedWordList().contains(where: { $0.uuid == deleteTarget.uuid }))
    }

    func test_getWordList() {
        // Arrange
        let preparedList = [unmemorizedWordList, memorizedWordList].flatMap { $0 }

        // Act
        let wordList = sut.getWordList()

        // Assert
        XCTAssertEqual(Set(wordList), Set(preparedList))
    }

    func test_updateUnmemorizedWordLiteral() {
        // Arrange
        guard let updateTarget: Word = unmemorizedWordList.last else {
            return XCTFail("'unmemorizedWordList' property is empty.")
        }
        updateTarget.word = "UpdatedWord"

        // Act
        sut.updateWord(by: updateTarget.uuid, to: updateTarget)

        // Assert
        XCTAssertEqual(sut.getWord(by: updateTarget.uuid)?.word, "UpdatedWord")
        XCTAssertEqual(sut.getWord(by: updateTarget.uuid)?.memorizedState, .memorizing)
    }

    func test_updateUnmemorizedWordToMemorized() {
        // Arrange
        guard let updateTarget: Word = unmemorizedWordList.last else {
            return XCTFail("'unmemorizedWordList' property is empty.")
        }
        updateTarget.memorizedState = .memorized

        // Act
        sut.updateWord(by: updateTarget.uuid, to: updateTarget)

        // Assert
        XCTAssertEqual(sut.getWord(by: updateTarget.uuid)?.memorizedState, .memorized)
    }

    func test_updateMemorizedWordToUnmemorized() {
        // Arrange
        guard let updateTarget: Word = memorizedWordList.last else {
            return XCTFail("'memorizedWordList' property is empty.")
        }
        updateTarget.memorizedState = .memorizing

        // Act
        sut.updateWord(by: updateTarget.uuid, to: updateTarget)

        // Assert
        XCTAssertEqual(sut.getWord(by: updateTarget.uuid)?.memorizedState, .memorizing)
    }

    func test_randomizeUnmemorizedWordListWhenOnly1Element() {
        // Arrange
        let testWord = unmemorizedWordList[0]

        (1..<5).forEach { index in
            sut.deleteWord(by: unmemorizedWordList[index].uuid)
        }

        // Act
        sut.randomizeUnmemorizedWordList()

        // Assert
        XCTAssertEqual(sut.getCurrentUnmemorizedWord(), testWord)
    }

    func test_randomizeUnmemorizedWordListWhenMoreThen2Element() {
        // Arrange
        let oldCurrentWord = sut.getCurrentUnmemorizedWord()

        // Act
        sut.randomizeUnmemorizedWordList()

        // Assert
        XCTAssertNotEqual(sut.getCurrentUnmemorizedWord(), oldCurrentWord)
    }

}

// MARK: - Helpers

extension WordUseCaseTests {

    func makePreparedWordRepository() -> WordRepositoryFake {
        let repository = WordRepositoryFake()
        zip(memorizedWordList, unmemorizedWordList).forEach {
            repository.save($0)
            repository.save($1)
        }
        return repository
    }

    func makePreparedUnmemorizedWordListRepository() -> UnmemorizedWordListRepositorySpy {
        let repository: UnmemorizedWordListRepositorySpy = .init()
        unmemorizedWordList.forEach {
            repository.addWord($0)
        }
        return repository
    }

}
