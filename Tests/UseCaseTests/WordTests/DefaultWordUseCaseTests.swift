//
//  Created by Jaewon Yun on 2023/09/04.
//

@testable import UseCase_Word
@testable import Domain_WordManagement
@testable import Domain_WordManagementTesting
@testable import Domain_WordMemorization
@testable import Domain_LocalNotification
@testable import Domain_LocalNotificationTesting

import RxBlocking
import XCTest

final class DefaultWordUseCaseTests: XCTestCase {

    var sut: DefaultWordUseCase!

    override func setUpWithError() throws {
        let wordRepository = FakeWordRepository()
        sut = DefaultWordUseCase(
            wordManagementService: DefaultWordManagementService(
                wordRepository: wordRepository,
                wordDuplicateSpecification: WordDuplicateSpecification(wordRepository: wordRepository)
            ),
            wordMemorizationService: DefaultWordMemorizationService(),
            localNotificationService: LocalNotificationServiceFake()
        )
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_addNewWord_whenFirst() throws {
        // When
        try sut.addNewWord("A")
            .toBlocking()
            .single()

        // Then
        XCTAssertEqual(sut.getCurrentUnmemorizedWord()?.word, "A")
    }

    func test_deleteWord() throws {
        // Given
        try ["A", "B", "C"].forEach { word in
            try sut.addNewWord(word)
                .toBlocking().single()
        }
        let currentWord = sut.getCurrentUnmemorizedWord()!
        
        // When
        try sut.deleteWord(by: currentWord.id)
            .toBlocking().single()

        // Then
        XCTAssertFalse(sut.fetchWordList().contains(where: { $0.word == currentWord.word }))
        XCTAssertEqual(sut.fetchWordList().count, 2)
        XCTAssertNotEqual(currentWord, sut.getCurrentUnmemorizedWord())
    }

    func test_fetchWordList() throws {
        // Given
        try ["A", "B", "C"].forEach { word in
            try sut.addNewWord(word)
                .toBlocking().single()
        }

        // When
        let wordList = sut.fetchWordList()

        // Then
        XCTAssertEqual(wordList.count, 3)
        XCTAssertEqual(Set(["C", "A", "B"]), Set(wordList.map(\.word)))
    }

    func test_updateWord_whenOnlyUpdateWord() throws {
        // Given
        try ["A", "B", "C"].forEach { word in
            try sut.addNewWord(word)
                .toBlocking().single()
        }
        let currentWord = sut.getCurrentUnmemorizedWord()!

        // When
        try sut.updateWord(by: currentWord.id, with: WordAttribute(word: "Update"))
            .toBlocking().single()

        // Then
        XCTAssertTrue(sut.fetchWordList().contains(where: { $0.word == "Update" }))
        XCTAssertEqual(sut.getCurrentUnmemorizedWord()?.word, "Update")
    }

    func test_updateWord_whenMemorizingToMemorized() throws {
        // Given
        try ["A", "B", "C"].forEach { word in
            try sut.addNewWord(word)
                .toBlocking().single()
        }
        let currentWord = sut.getCurrentUnmemorizedWord()!
        
        // When
        try sut.updateWord(by: currentWord.id, with: WordAttribute(memorizationState: .memorized))
            .toBlocking().single()

        // Then
        let updatedWord = try sut.fetchWord(by: currentWord.id)
            .toBlocking().single()
        XCTAssertNotEqual(currentWord.word, sut.getCurrentUnmemorizedWord()?.word)
        XCTAssertEqual(updatedWord.memorizationState, .memorized)
    }

    func test_updateWord_whenMemorizedToMemorizing() throws {
        // Given
        try ["A", "B", "C"].forEach { word in
            try sut.addNewWord(word)
                .toBlocking().single()
        }
        let currentWord = sut.getCurrentUnmemorizedWord()!
        try sut.markCurrentWordAsMemorized()
            .toBlocking().single()

        // When
        try sut.updateWord(by: currentWord.id, with: WordAttribute(memorizationState: .memorizing))
            .toBlocking().single()

        // Then
        let word = try sut.fetchWord(by: currentWord.id)
            .toBlocking().single()
        XCTAssertEqual(word.memorizationState, .memorizing)
        XCTAssertNotEqual(currentWord.word, sut.getCurrentUnmemorizedWord()?.word)
    }

    func test_shuffleUnmemorizedWordList_whenOnly1Element() throws {
        // Given
        try ["A"].forEach { word in
            try sut.addNewWord(word)
                .toBlocking().single()
        }

        // When
        sut.shuffleUnmemorizedWordList()

        // Then
        XCTAssertEqual(sut.getCurrentUnmemorizedWord()?.word, "A")
    }

    func test_shuffleUnmemorizedWordList_whenMoreThen2Element() throws {
        // Given
        try ["A", "B"].forEach { word in
            try sut.addNewWord(word)
                .toBlocking().single()
        }
        let currentWord = sut.getCurrentUnmemorizedWord()!

        // When
        sut.shuffleUnmemorizedWordList()

        // Then
        XCTAssertNotEqual(sut.getCurrentUnmemorizedWord()?.word, currentWord.word)
    }

    func test_addNewWord_whenDuplicated() throws {
        // Given
        try ["A"].forEach { word in
            try sut.addNewWord(word)
                .toBlocking().single()
        }

        // When
        let addNewWord = sut.addNewWord("A")
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
        try ["A"].forEach { word in
            try sut.addNewWord(word)
                .toBlocking().single()
        }

        // When
        let isWordDuplicated = try sut.isWordDuplicated("A")
            .toBlocking().single()

        // Then
        XCTAssertTrue(isWordDuplicated)
    }

    func test_updateWord_willThrowError_whenDuplicated_withDifferentCaseSensitivity() throws {
        // Given
        try ["A", "B"].forEach { word in
            try sut.addNewWord(word)
                .toBlocking().single()
        }
        let word = sut.fetchWordList().first(where: { $0.word == "A" })!
        
        // When
        let updateWord = sut.updateWord(by: word.id, with: WordAttribute(word: "b"))
            .toBlocking()

        // Then
        XCTAssertThrowsError(try updateWord.single())
    }

    func test_updateWord_willChangeDailyReminderMessage_afterMemorizedAllWords() async throws {
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
        
        sut = DefaultWordUseCase(
            wordManagementService: DefaultWordManagementService(
                wordRepository: wordRepositoryFake,
                wordDuplicateSpecification: WordDuplicateSpecification(wordRepository: wordRepositoryFake)
            ),
            wordMemorizationService: DefaultWordMemorizationService(),
            localNotificationService: localNotificationServiceFake
        )
        
        // When
        try sut.updateWord(by: uuid, with: WordAttribute(memorizationState: .memorized))
            .toBlocking().single()
        
        // Then
        XCTAssertEqual(localNotificationServiceFake.pendingDailyReminder?.unmemorizedWordCount, 0)
    }
    
    func test_markCurrentWordAsMemorized() throws {
        // Given
        try ["A", "B", "C"].forEach { word in
            try sut.addNewWord(word)
                .toBlocking().single()
        }
        let currentWord = sut.getCurrentUnmemorizedWord()!
        
        // When
        try sut.markCurrentWordAsMemorized()
            .toBlocking().single()
        
        // Then
        let wordList = sut.fetchWordList()
        let oldCurrentWord = wordList.first(where: { $0.word == currentWord.word })!
        XCTAssertEqual(oldCurrentWord.memorizationState, .memorized)
    }
}
