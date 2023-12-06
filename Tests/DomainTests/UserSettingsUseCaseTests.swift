//
//  UserSettingsUseCaseTests.swift
//  DomainUnitTests
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import Domain

import DataDriverTesting
import RxBlocking
import TestsSupport
import XCTest

final class UserSettingsUseCaseTests: XCTestCase {

    var sut: UserSettingsUseCaseProtocol!
    var notificationCenterFake: UNUserNotificationCenterFake!

    override func setUpWithError() throws {
        try super.setUpWithError()

        let userSettingsRepository: UserSettingsRepositoryProtocol = UserSettingsRepositoryFake()
        notificationCenterFake = .init()

        sut = UserSettingsUseCase.init(
            userSettingsRepository: userSettingsRepository,
            notificationCenter: notificationCenterFake
        )
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
        notificationCenterFake = nil
    }

    func testSetToOtherTranslationLocale() throws {
        // Act1
        do {
            try sut.updateTranslationLocale(source: .english, target: .korean)
                .toBlocking()
                .single()

            let currentTranslationLocale = try sut.getCurrentTranslationLocale()
                .toBlocking()
                .single()

            XCTAssertEqual(currentTranslationLocale.source, .english)
            XCTAssertEqual(currentTranslationLocale.target, .korean)
        }

        // Act2
        do {
            try sut.updateTranslationLocale(source: .korean, target: .english)
                .toBlocking()
                .single()

            let currentTranslationLocale = try sut.getCurrentTranslationLocale()
                .toBlocking()
                .single()

            XCTAssertEqual(currentTranslationLocale.source, .korean)
            XCTAssertEqual(currentTranslationLocale.target, .english)
        }
    }

    func test_getLatestDailyReminderTime_whenNeverSetDailyReminder() {
        XCTAssertThrowsError(try sut.getLatestDailyReminderTime())
    }

    func test_removeDailyReminder() throws {
        // Given
        let time: DateComponents = .init(hour: 11, minute: 11)
        try sut.setDailyReminder(at: time)
            .toBlocking()
            .single()
        XCTAssertEqual(notificationCenterFake._pendingNotifications.count, 1)

        // When
        sut.removeDailyReminder()

        // Then
        XCTAssertEqual(notificationCenterFake._pendingNotifications.count, 0)
    }

    func test_getLatestDailyReminderTime_afterTurnOffDailyReminder() throws {
        // Given
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
        let time: DateComponents = .init(hour: 11, minute: 11)
        try sut.setDailyReminder(at: time)
            .toBlocking()
            .single()

        // When
        let newTime: DateComponents = .init(hour: 12, minute: 12)
        try sut.updateDailyReminerTime(to: newTime)
            .toBlocking()
            .single()

        // Then
        let latestTime = try sut.getLatestDailyReminderTime()
        XCTAssertEqual(latestTime, newTime)
    }

}
