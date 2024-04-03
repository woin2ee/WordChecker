//
//  Created by Jaewon Yun on 1/24/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

@testable import UseCase_LocalNotification
@testable import Domain_LocalNotification
@testable import Domain_LocalNotificationTesting
@testable import Domain_Word
@testable import Domain_WordTesting

import RxBlocking
import XCTest

final class DefaultNotificationsUseCaseTests: XCTestCase {

    var sut: DefaultNotificationsUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = .init(localNotificationService: LocalNotificationServiceFake(), wordService: WordServiceStub())
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func test_setDailyReminder_whenNoAuthorized() {
        // Given
        let time: DateComponents = .init(hour: 11, minute: 11)

        // When
        do {
            try sut.setDailyReminder(at: time)
                .toBlocking()
                .single()

            XCTFail("에러 발생하지 않음")
        }

        // Then
        catch {
            XCTAssertEqual(error as? LocalNotificationServiceError, LocalNotificationServiceError.notificationNotAuthorized)
        }
    }

    func test_setDailyReminder_whenAuthorized() throws {
        // Given
        let isAuthorized = try sut.requestNotificationAuthorization(with: .alert)
            .toBlocking()
            .single()
        XCTAssertTrue(isAuthorized)

        let noticeTime = NoticeTime(hour: 11, minute: 11)

        // When
        try sut.setDailyReminder(at: DateComponents(hour: noticeTime.hour, minute: noticeTime.minute))
            .toBlocking()
            .single()

        // Then
        let dailyReminder = try sut.getDailyReminder()
            .toBlocking()
            .single()

        XCTAssertEqual(dailyReminder.noticeTime, noticeTime)
    }

    func test_setDailyReminder_whenNoWordsToMemorize() throws {
        // Given
        _ = try sut.requestNotificationAuthorization(with: .alert)
            .toBlocking()
            .single()

        // When
        let setDailyReminderSequence = sut.setDailyReminder(at: .init(hour: 11, minute: 11))
            .toBlocking()

        // Then
        XCTAssertNoThrow(try setDailyReminderSequence.single())
    }

    func test_getLatestDailyReminderTime_whenNeverSetDailyReminder() {
        XCTAssertThrowsError(try sut.getLatestDailyReminderTime())
    }

    func test_removeDailyReminder() throws {
        // Given
        let isAuthorized = try sut.requestNotificationAuthorization(with: .alert)
            .toBlocking()
            .single()
        XCTAssertTrue(isAuthorized)

        let time: DateComponents = .init(hour: 11, minute: 11)
        try sut.setDailyReminder(at: time)
            .toBlocking()
            .single()

        // When
        sut.removeDailyReminder()

        // Then
        XCTAssertThrowsError(
            try sut.getDailyReminder()
                .toBlocking()
                .single()
        )
    }

    func test_getLatestDailyReminderTime_afterTurnOffDailyReminder() throws {
        // Given
        let isAuthorized = try sut.requestNotificationAuthorization(with: .alert)
            .toBlocking()
            .single()
        XCTAssertTrue(isAuthorized)

        let time: DateComponents = .init(hour: 11, minute: 11)
        
        try sut.setDailyReminder(at: time).toBlocking().single()
        sut.removeDailyReminder()

        // When
        let latestTime = try sut.getLatestDailyReminderTime()

        // Then
        XCTAssertEqual(latestTime, time)
    }

    func test_updateDailyReminerTime() throws {
        // Given
        let isAuthorized = try sut.requestNotificationAuthorization(with: .alert)
            .toBlocking()
            .single()
        XCTAssertTrue(isAuthorized)

        let noticeTime = NoticeTime(hour: 11, minute: 11)
        try sut.setDailyReminder(at: DateComponents(hour: noticeTime.hour, minute: noticeTime.minute))
            .toBlocking()
            .single()

        // When
        let newNoticeTime = NoticeTime(hour: 12, minute: 12)
        try sut.setDailyReminder(at: DateComponents(hour: newNoticeTime.hour, minute: newNoticeTime.minute))
            .toBlocking()
            .single()

        // Then
        let latestTime = try sut.getLatestDailyReminderTime()
        XCTAssertEqual(latestTime.hour, newNoticeTime.hour)
        XCTAssertEqual(latestTime.minute, newNoticeTime.minute)

        let dailyReminder = try sut.getDailyReminder()
            .toBlocking()
            .single()
        XCTAssertEqual(dailyReminder.noticeTime, newNoticeTime)
    }

    func test_updateDailyReminder() throws {
        // Given
        let word1UUID = UUID()
        let word1 = try Word(uuid: word1UUID, word: "Test1", memorizedState: .memorizing)
        let word2 = try Word(uuid: UUID(), word: "Test2", memorizedState: .memorizing)
        let wordRepositoryFake = WordRepositoryFake(sampleData: [word1, word2])
        
        sut = .init(
            localNotificationService: LocalNotificationServiceFake(),
            wordService: DefaultWordService(
                wordRepository: wordRepositoryFake,
                unmemorizedWordListRepository: UnmemorizedWordListRepository(),
                wordDuplicateSpecification: WordDuplicateSpecification(wordRepository: wordRepositoryFake)
            )
        )
        
        _ = try sut.requestNotificationAuthorization(with: .alert) // Authorization
            .toBlocking()
            .single()

        try sut.setDailyReminder(at: .init(hour: 11, minute: 11)) // Prepare daily reminder
            .toBlocking()
            .single()

        let originDailyReminder = try sut.getDailyReminder()
            .toBlocking()
            .single()

        // Wheni
        wordRepositoryFake.deleteWord(by: word1UUID)

        _ = try sut.updateDailyReminder()
            .toBlocking()
            .first()

        // Then
        let newDailyReminder = try sut.getDailyReminder()
            .toBlocking()
            .single()

        XCTAssertNotEqual(originDailyReminder.unmemorizedWordCount, newDailyReminder.unmemorizedWordCount)
    }

}
