//
//  Created by Jaewon Yun on 2023/09/04.
//

@testable import UseCase_Word
@testable import Domain_WordManagement
@testable import Domain_WordManagementTesting
@testable import Domain_LocalNotification
@testable import Domain_LocalNotificationTesting

import RxBlocking
import XCTest

final class DefaultWordUseCaseTests: XCTestCase {

    var sut: DefaultWordUseCase!

    let memorizedWordList: [Word] = [
        try! .init(word: "F", memorizationState: .memorized),
        try! .init(word: "G", memorizationState: .memorized),
        try! .init(word: "H", memorizationState: .memorized),
        try! .init(word: "I", memorizationState: .memorized),
        try! .init(word: "J", memorizationState: .memorized),
    ]

    let unmemorizedWordList: [Word] = [
        try! .init(word: "A"),
        try! .init(word: "B"),
        try! .init(word: "C"),
        try! .init(word: "D"),
        try! .init(word: "E"),
    ]

    override func setUpWithError() throws {
        try super.setUpWithError()

        let (wordRepositoryFake, unmemorizedWordListRepository) = makePreparedRepositories()
        
        sut = DefaultWordUseCase(
            wordService: DefaultWordService(
                wordRepository: wordRepositoryFake,
                unmemorizedWordListRepository: unmemorizedWordListRepository,
                wordDuplicateSpecification: WordDuplicateSpecification(wordRepository: wordRepositoryFake)
            ),
            localNotificationService: LocalNotificationServiceFake()
        )
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
    }

    func test_addNewWord() throws {
        // Arrange
        let beforeCount = sut.fetchWordList().count
        
        // Act
        try sut.addNewWord("Not duplicate word")
            .toBlocking()
            .single()

        // Assert
        XCTAssertEqual(sut.fetchWordList().count, beforeCount + 1)
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
        XCTAssertThrowsError(try sut.fetchWord(by: deleteTarget.uuid).toBlocking().single())
        XCTAssertFalse(sut.fetchUnmemorizedWordList().contains(where: { $0.uuid == deleteTarget.uuid }))
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
        XCTAssertThrowsError(try sut.fetchWord(by: deleteTarget.uuid).toBlocking().single())
        XCTAssertFalse(sut.fetchMemorizedWordList().contains(where: { $0.uuid == deleteTarget.uuid }))
    }

    func test_getWordList() throws {
        // Arrange
        let preparedList = [unmemorizedWordList, memorizedWordList].flatMap { $0 }

        // Act
        let wordList = sut.fetchWordList()

        // Assert
        XCTAssertEqual(Set(wordList), Set(preparedList))
    }

    func test_updateUnmemorizedWordLiteral() throws {
        // Arrange
        guard let updateTarget: Word = unmemorizedWordList.last else {
            return XCTFail("'unmemorizedWordList' property is empty.")
        }

        // Act
        try sut.updateWord(by: updateTarget.uuid, with: WordAttribute(word: "UpdatedWord"))
            .toBlocking()
            .single()

        // Assert
        XCTAssertEqual(try sut.fetchWord(by: updateTarget.uuid).toBlocking().single().word, "UpdatedWord")
        XCTAssertEqual(try sut.fetchWord(by: updateTarget.uuid).toBlocking().single().memorizationState, .memorizing)
    }

    func test_updateUnmemorizedWordToMemorized() throws {
        // Arrange
        guard let updateTarget: Word = unmemorizedWordList.last else {
            return XCTFail("'unmemorizedWordList' property is empty.")
        }

        // Act
        try sut.updateWord(by: updateTarget.uuid, with: WordAttribute(memorizationState: .memorized))
            .toBlocking()
            .single()

        // Assert
        XCTAssertEqual(try sut.fetchWord(by: updateTarget.uuid).toBlocking().single().memorizationState, .memorized)
    }

    func test_updateMemorizedWordToUnmemorized() throws {
        // Arrange
        guard let updateTarget: Word = memorizedWordList.last else {
            return XCTFail("'memorizedWordList' property is empty.")
        }

        // Act
        try sut.updateWord(by: updateTarget.uuid, with: WordAttribute(memorizationState: .memorizing))
            .toBlocking()
            .single()

        // Assert
        XCTAssertEqual(try sut.fetchWord(by: updateTarget.uuid).toBlocking().single().memorizationState, .memorizing)
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
        sut.shuffleUnmemorizedWordList()

        // Assert
        XCTAssertEqual(sut.getCurrentUnmemorizedWord(), testWord)
    }

    func test_shuffleUnmemorizedWordListWhenMoreThen2Element() throws {
        // Arrange
        let oldCurrentWord = sut.getCurrentUnmemorizedWord()

        // Act
        sut.shuffleUnmemorizedWordList()

        // Assert
        XCTAssertNotEqual(sut.getCurrentUnmemorizedWord(), oldCurrentWord)
    }

    func test_addDuplicatedWord() throws {
        // Given
        let newWord = unmemorizedWordList[0].word

        // When
        let addNewWord = sut.addNewWord(newWord)
            .toBlocking()

        // Then
        XCTAssertThrowsError(try addNewWord.single()) { error in
            switch error {
            case WordServiceError.saveFailed(reason: .duplicatedWord):
                break
            default:
                XCTFail("예상되지 않은 에러 던져짐.")
            }
        }
    }

    func test_isWordDuplicated() throws {
        // Given
        let duplicatedWord = unmemorizedWordList[0]

        // When
        let isWordDuplicated = try sut.isWordDuplicated(duplicatedWord.word)
            .toBlocking()
            .single()

        // Then
        XCTAssertTrue(isWordDuplicated)
    }

    func test_throwError_whenUpdateToDuplicatedWordWithDiffCase() {
        // Given
        let targetUUID = unmemorizedWordList[0].uuid
        let duplicateWord = "j"

        // When
        let updateWord = sut.updateWord(by: targetUUID, with: WordAttribute(word: duplicateWord))
            .toBlocking()

        // Then
        XCTAssertThrowsError(try updateWord.single())
    }

    func test_dailyReminderMessage_whenCompleteMemorizingLastWord() async throws {
        // Given
        let uuid = UUID()
        let word = try Word(uuid: uuid, word: "Test", memorizationState: .memorizing)
        
        let wordRepositoryFake = FakeWordRepository()
        wordRepositoryFake.save(word)
        
        let localNotificationServiceFake = LocalNotificationServiceFake()
        _ = try await localNotificationServiceFake.requestAuthorization(options: .alert)
        
        let dailyReminder = DailyReminder(
            unmemorizedWordCount: 1,
            noticeTime: NoticeTime(hour: 11, minute: 11)
        )
        try await localNotificationServiceFake.setDailyReminder(dailyReminder)
        
        sut = .init(
            wordService: DefaultWordService(
                wordRepository: wordRepositoryFake,
                unmemorizedWordListRepository: UnmemorizedWordListRepository(),
                wordDuplicateSpecification: WordDuplicateSpecification(wordRepository: wordRepositoryFake)
            ),
            localNotificationService: localNotificationServiceFake
        )
        
        // When
        try sut.updateWord(by: uuid, with: WordAttribute(memorizationState: .memorized))
            .toBlocking()
            .single()
        
        // Then
        XCTAssertEqual(localNotificationServiceFake.pendingDailyReminder?.unmemorizedWordCount, 0)
    }
}

// MARK: - Helpers

extension DefaultWordUseCaseTests {

    private func makePreparedRepositories() -> (wordRepositoryFake: FakeWordRepository, unmemorizedWordListRepository: UnmemorizedWordListRepository) {
        let wordRepositoryFake = FakeWordRepository()
        zip(memorizedWordList, unmemorizedWordList).forEach {
            wordRepositoryFake.save($0)
            wordRepositoryFake.save($1)
        }
        
        let unmemorizedWordListRepository: UnmemorizedWordListRepository = .init()
        unmemorizedWordList.forEach {
            unmemorizedWordListRepository.addWord($0)
        }
       
        return (wordRepositoryFake, unmemorizedWordListRepository)
    }
}
