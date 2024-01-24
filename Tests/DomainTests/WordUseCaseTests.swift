//
//  WordUseCaseTests.swift
//  WordUseCaseTests
//
//  Created by Jaewon Yun on 2023/09/04.
//

@testable import Domain
@testable import Utility

import DataDriverTesting
import DomainTesting
import RxBlocking
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

    let notificationsUseCase = NotificationsUseCaseMock(expectedAuthorizationStatus: .authorized)

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = WordUseCase.init(
            wordRepository: makePreparedWordRepository(),
            unmemorizedWordListRepository: makePreparedUnmemorizedWordListRepository(),
            notificationsUseCase: notificationsUseCase
        )
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
    }

    func test_addNewWord() throws {
        // Arrange
        guard let testUUID: UUID = .init(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F") else {
            return XCTFail("Failed to initialize uuid.")
        }
        let testWord: Word = .init(uuid: testUUID, word: "Test", memorizedState: .memorizing)

        // Act
        try sut.addNewWord(testWord)
            .toBlocking()
            .single()

        // Assert
        XCTAssertEqual(try sut.getWord(by: testUUID).toBlocking().single(), testWord)
        XCTAssertEqual(notificationsUseCase.resetDailyReminderCallCount, 1)
    }

    func test_deleteUnmemorizedWord() throws {
        // Arrange
        guard let deleteTarget: Word = unmemorizedWordList.last else {
            return XCTFail("'unmemorizedWordList' property is empty.")
        }

        // Act
        try sut.deleteWord(by: deleteTarget.uuid)
            .toBlocking()
            .single()

        // Assert
        XCTAssertThrowsError(try sut.getWord(by: deleteTarget.uuid).toBlocking().single())
        XCTAssertFalse(try sut.getUnmemorizedWordList().toBlocking().single().contains(where: { $0.uuid == deleteTarget.uuid }))
        XCTAssertEqual(notificationsUseCase.resetDailyReminderCallCount, 1)
    }

    func test_deleteMemorizedWord() throws {
        // Arrange
        guard let deleteTarget: Word = memorizedWordList.last else {
            return XCTFail("'memorizedWordList' property is empty.")
        }

        // Act
        try sut.deleteWord(by: deleteTarget.uuid)
            .toBlocking()
            .single()

        // Assert
        XCTAssertThrowsError(try sut.getWord(by: deleteTarget.uuid).toBlocking().single())
        XCTAssertFalse(try sut.getMemorizedWordList().toBlocking().single().contains(where: { $0.uuid == deleteTarget.uuid }))
        XCTAssertEqual(notificationsUseCase.resetDailyReminderCallCount, 1)
    }

    func test_getWordList() throws {
        // Arrange
        let preparedList = [unmemorizedWordList, memorizedWordList].flatMap { $0 }

        // Act
        let wordList = try sut.getWordList()
            .toBlocking()
            .single()

        // Assert
        XCTAssertEqual(Set(wordList), Set(preparedList))
    }

    func test_updateUnmemorizedWordLiteral() throws {
        // Arrange
        guard let updateTarget: Word = unmemorizedWordList.last else {
            return XCTFail("'unmemorizedWordList' property is empty.")
        }
        updateTarget.word = "UpdatedWord"

        // Act
        try sut.updateWord(by: updateTarget.uuid, to: updateTarget)
            .toBlocking()
            .single()

        // Assert
        XCTAssertEqual(try sut.getWord(by: updateTarget.uuid).toBlocking().single().word, "UpdatedWord")
        XCTAssertEqual(try sut.getWord(by: updateTarget.uuid).toBlocking().single().memorizedState, .memorizing)
    }

    func test_updateUnmemorizedWordToMemorized() throws {
        // Arrange
        guard let updateTarget: Word = unmemorizedWordList.last else {
            return XCTFail("'unmemorizedWordList' property is empty.")
        }
        updateTarget.memorizedState = .memorized

        // Act
        try sut.updateWord(by: updateTarget.uuid, to: updateTarget)
            .toBlocking()
            .single()

        // Assert
        XCTAssertEqual(try sut.getWord(by: updateTarget.uuid).toBlocking().single().memorizedState, .memorized)
    }

    func test_updateMemorizedWordToUnmemorized() throws {
        // Arrange
        guard let updateTarget: Word = memorizedWordList.last else {
            return XCTFail("'memorizedWordList' property is empty.")
        }
        updateTarget.memorizedState = .memorizing

        // Act
        try sut.updateWord(by: updateTarget.uuid, to: updateTarget)
            .toBlocking()
            .single()

        // Assert
        XCTAssertEqual(try sut.getWord(by: updateTarget.uuid).toBlocking().single().memorizedState, .memorizing)
    }

    func test_shuffleUnmemorizedWordListWhenOnly1Element() throws {
        // Arrange
        let testWord = unmemorizedWordList[0]

        (1..<5).forEach { index in
            try? sut.deleteWord(by: unmemorizedWordList[index].uuid)
                .toBlocking()
                .single()
        }

        // Act
        try sut.shuffleUnmemorizedWordList()
            .toBlocking()
            .single()

        // Assert
        XCTAssertEqual(try sut.getCurrentUnmemorizedWord().toBlocking().single(), testWord)
    }

    func test_shuffleUnmemorizedWordListWhenMoreThen2Element() throws {
        // Arrange
        let oldCurrentWord = try sut.getCurrentUnmemorizedWord()
            .toBlocking()
            .single()

        // Act
        try sut.shuffleUnmemorizedWordList()
            .toBlocking()
            .single()

        // Assert
        XCTAssertNotEqual(try sut.getCurrentUnmemorizedWord().toBlocking().single(), oldCurrentWord)
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
