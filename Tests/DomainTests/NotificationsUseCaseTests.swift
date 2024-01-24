//
//  NotificationsUseCaseTests.swift
//  DomainTests
//
//  Created by Jaewon Yun on 1/24/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

@testable import Domain

import DataDriverTesting
import RxBlocking
import TestsSupport
import XCTest

final class NotificationsUseCaseTests: XCTestCase {

    var sut: NotificationsUseCaseProtocol!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NotificationsUseCase.init(
            notificationRepository: UNUserNotificationCenterFake(),
            wordRepository: WordRepositoryFake(),
            userSettingsRepository: UserSettingsRepositoryFake()
        )
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
            XCTAssertEqual(error as? UserSettingsUseCaseError, UserSettingsUseCaseError.noNotificationAuthorization)
        }
    }

    func test_setDailyReminder_whenAuthorized() throws {
        // Given
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

}
