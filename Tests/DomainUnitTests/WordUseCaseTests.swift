//
//  WordUseCaseTests.swift
//  WordUseCaseTests
//
//  Created by Jaewon Yun on 2023/09/04.
//

import Domain
import Testing
@testable import Utility
import XCTest

final class WordUseCaseTests: XCTestCase {

    var sut: WordUseCaseProtocol!

    var wordRepository: WordRepositoryFake!
    var unmemorizedWordListRepository: UnmemorizedWordListRepositorySpy!

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

        wordRepository = makePreparedWordRepository()
        unmemorizedWordListRepository = makePreparedUnmemorizedWordListRepository()

        sut = WordUseCase.init(
            wordRepository: wordRepository,
            unmemorizedWordListRepository: unmemorizedWordListRepository
        )
    }

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

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
        wordRepository = nil
        unmemorizedWordListRepository = nil
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
        XCTAssert(wordRepository._wordList.contains(where: { $0.uuid == testUUID }))
        XCTAssert(unmemorizedWordListRepository._storedWords.contains(where: { $0.uuid == testUUID }))
    }

    func test_deleteUnmemorizedWord() {
        // Arrange
        guard let deleteTarget: Word = unmemorizedWordList.last else {
            return XCTFail("'unmemorizedWordList' property is empty.")
        }

        // Act
        sut.deleteWord(by: deleteTarget.uuid)

        // Assert
        XCTAssertFalse(wordRepository._wordList.contains(where: { $0.uuid == deleteTarget.uuid }))
        XCTAssertEqual(unmemorizedWordListRepository._storedWords.count, unmemorizedWordList.count - 1)
    }

    func test_deleteMemorizedWord() {
        // Arrange
        guard let deleteTarget: Word = memorizedWordList.last else {
            return XCTFail("'memorizedWordList' property is empty.")
        }

        // Act
        sut.deleteWord(by: deleteTarget.uuid)

        // Assert
        XCTAssertFalse(wordRepository._wordList.contains(where: { $0.uuid == deleteTarget.uuid }))
        XCTAssertEqual(unmemorizedWordListRepository._storedWords.count, unmemorizedWordList.count)
    }

    func test_getWordList() {
        // Arrange
        let preparedList = [unmemorizedWordList, memorizedWordList].flatMap { $0 }

        // Act
        let wordList = sut.getWordList()

        // Assert
        wordList.forEach { word in
            XCTAssert(preparedList.contains(where: { $0.uuid == word.uuid }))
        }
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
        XCTAssertEqual(wordRepository._wordList.first(where: { $0.uuid == updateTarget.uuid })?.word, "UpdatedWord")
        XCTAssertEqual(unmemorizedWordListRepository._storedWords.first(where: { $0.uuid == updateTarget.uuid })?.word, "UpdatedWord")
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
        XCTAssertEqual(wordRepository._wordList.first(where: { $0.uuid == updateTarget.uuid }), updateTarget)
        XCTAssertFalse(unmemorizedWordListRepository._storedWords.contains(where: { $0.uuid == updateTarget.uuid }))
    }

    func test_updateMemorizedWordToUnMemorized() {
        // Arrange
        guard let updateTarget: Word = memorizedWordList.last else {
            return XCTFail("'memorizedWordList' property is empty.")
        }
        updateTarget.memorizedState = .memorizing

        // Act
        sut.updateWord(by: updateTarget.uuid, to: updateTarget)

        // Assert
        XCTAssertEqual(wordRepository._wordList.first(where: { $0.uuid == updateTarget.uuid }), updateTarget)
        XCTAssert(unmemorizedWordListRepository._storedWords.contains(where: { $0.uuid == updateTarget.uuid }))
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
        XCTAssertEqual(sut.currentUnmemorizedWord, testWord)
    }

    func test_randomizeUnmemorizedWordListWhenMoreThen2Element() {
        // Arrange
        let oldCurrentWord = sut.currentUnmemorizedWord

        // Act
        sut.randomizeUnmemorizedWordList()

        // Assert
        XCTAssertNotEqual(sut.currentUnmemorizedWord, oldCurrentWord)
    }

}
