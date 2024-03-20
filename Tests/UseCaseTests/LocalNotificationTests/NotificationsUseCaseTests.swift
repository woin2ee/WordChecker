//
//  NotificationsUseCaseTests.swift
//  DomainTests
//
//  Created by Jaewon Yun on 1/24/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

@testable import Domain_Notification
import Domain_NotificationInterface
import Domain_NotificationTesting

import Domain_WordInterface
import Domain_WordTesting

import RxBlocking
import TestsSupport
import XCTest

final class NotificationsUseCaseTests: XCTestCase {

    var sut: NotificationsUseCaseProtocol!

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func test_setDailyReminder_whenNoAuthorized() {
        // Given
        sut = NotificationsUseCase.init(
            localNotificationService: LocalNotificationServiceFake(),
            wordRepository: WordRepositoryFake(sampleData: [try! Word(word: "Test", memorizedState: .memorizing)])
        )

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
            XCTAssertEqual(error as? NotificationUseCaseError, NotificationUseCaseError.noNotificationAuthorization)
        }
    }

    func test_setDailyReminder_whenAuthorized() throws {
        // Given
        sut = NotificationsUseCase.init(
            localNotificationService: LocalNotificationServiceFake(),
            wordRepository: WordRepositoryFake(sampleData: [try! Word(word: "Test", memorizedState: .memorizing)])
        )

        let isAuthorized = try sut.requestNotificationAuthorization(with: .alert)
            .toBlocking()
            .single()
        XCTAssertTrue(isAuthorized)

        let time: DateComponents = .init(hour: 11, minute: 11)

        // When
        try sut.setDailyReminder(at: time)
            .toBlocking()
            .single()

        // Then
        let dailyReminder = try sut.getDailyReminder()
            .toBlocking()
            .single()

        XCTAssertEqual((dailyReminder.trigger as? UNCalendarNotificationTrigger)?.dateComponents, time)
    }

    func test_setDailyReminder_whenJustNoWords() throws {
        // Given
        sut = NotificationsUseCase.init(
            localNotificationService: LocalNotificationServiceFake(),
            wordRepository: WordRepositoryFake(sampleData: [])
        )

        _ = try sut.requestNotificationAuthorization(with: .alert)
            .toBlocking()
            .single()

        // When
        let setDailyReminderSequence = sut.setDailyReminder(at: .init(hour: 11, minute: 11))
            .toBlocking()

        // Then
        XCTAssertNoThrow(try setDailyReminderSequence.single())
    }

    func test_setDailyReminder_whenNoWordsToMemorize() throws {
        // Given
        sut = NotificationsUseCase.init(
            localNotificationService: LocalNotificationServiceFake(),
            wordRepository: WordRepositoryFake(sampleData: [try! Word(word: "Test", memorizedState: .memorized)])
        )

        _ = try sut.requestNotificationAuthorization(with: .alert)
            .toBlocking()
            .single()

        // When
        let setDailyReminderSequence = sut.setDailyReminder(at: .init(hour: 11, minute: 11))
            .toBlocking()

        // Then
        XCTAssertNoThrow(try setDailyReminderSequence.single())
    }

    func test_setDailyReminder_whenDailyReminderExistsAndAllWordsMemorized() throws {
        // Given
        let uuid: UUID = .init()
        let wordRepository = WordRepositoryFake(sampleData: [try! Word(uuid: uuid, word: "Test", memorizedState: .memorizing)])
        sut = NotificationsUseCase.init(
            localNotificationService: LocalNotificationServiceFake(),
            wordRepository: wordRepository
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

        wordRepository.save(try! .init(uuid: uuid, word: "Test", memorizedState: .memorized)) // All words memorized

        // When
        let setDailyReminderSequence = sut.setDailyReminder(at: .init(hour: 11, minute: 11))
            .toBlocking()

        // Then
        XCTAssertNoThrow(try setDailyReminderSequence.single())
        let newDailyReminder = try sut.getDailyReminder()
            .toBlocking()
            .single()
        XCTAssertNotEqual(originDailyReminder.content.body, newDailyReminder.content.body)
    }

    func test_getLatestDailyReminderTime_whenNeverSetDailyReminder() {
        // Given
        sut = NotificationsUseCase.init(
            localNotificationService: LocalNotificationServiceFake(),
            wordRepository: WordRepositoryFake()
        )

        // Then
        XCTAssertThrowsError(try sut.getLatestDailyReminderTime())
    }

    func test_removeDailyReminder() throws {
        // Given
        sut = NotificationsUseCase.init(
            localNotificationService: LocalNotificationServiceFake(),
            wordRepository: WordRepositoryFake(sampleData: [try! Word(word: "Test", memorizedState: .memorizing)])
        )

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
        sut = NotificationsUseCase.init(
            localNotificationService: LocalNotificationServiceFake(),
            wordRepository: WordRepositoryFake(sampleData: [try! Word(word: "Test", memorizedState: .memorizing)])
        )

        let isAuthorized = try sut.requestNotificationAuthorization(with: .alert)
            .toBlocking()
            .single()
        XCTAssertTrue(isAuthorized)

        let time: DateComponents = .init(hour: 11, minute: 11)
        try sut.setDailyReminder(at: time)
            .toBlocking()
            .single()
        sut.removeDailyReminder()

        // When
        let latestTime = try sut.getLatestDailyReminderTime()

        // Then
        XCTAssertEqual(latestTime, time)
    }

    func test_updateDailyReminerTime() throws {
        // Given
        sut = NotificationsUseCase.init(
            localNotificationService: LocalNotificationServiceFake(),
            wordRepository: WordRepositoryFake(sampleData: [try! Word(word: "Test", memorizedState: .memorizing)])
        )

        let isAuthorized = try sut.requestNotificationAuthorization(with: .alert)
            .toBlocking()
            .single()
        XCTAssertTrue(isAuthorized)

        let time: DateComponents = .init(hour: 11, minute: 11)
        try sut.setDailyReminder(at: time)
            .toBlocking()
            .single()

        // When
        let newTime: DateComponents = .init(hour: 12, minute: 12)
        try sut.setDailyReminder(at: newTime)
            .toBlocking()
            .single()

        // Then
        let latestTime = try sut.getLatestDailyReminderTime()
        XCTAssertEqual(latestTime, newTime)

        let dailyReminder = try sut.getDailyReminder()
            .toBlocking()
            .single()
        XCTAssertEqual((dailyReminder.trigger as? UNCalendarNotificationTrigger)?.dateComponents, newTime)
    }

    func test_updateDailyReminder() throws {
        // Given
        let wordRepository = WordRepositoryFake(sampleData: [try! Word(uuid: .init(), word: "Test1", memorizedState: .memorizing)])
        sut = NotificationsUseCase.init(
            localNotificationService: LocalNotificationServiceFake(),
            wordRepository: wordRepository
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

        // When
        wordRepository.save(try! .init(word: "Test2", memorizedState: .memorizing)) // Add word

        _ = try sut.updateDailyReminder()
            .toBlocking()
            .first()

        // Then
        let newDailyReminder = try sut.getDailyReminder()
            .toBlocking()
            .single()

        XCTAssertNotEqual(originDailyReminder.content.body, newDailyReminder.content.body)
    }

}
