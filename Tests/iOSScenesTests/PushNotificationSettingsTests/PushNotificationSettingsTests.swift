@testable import PushNotificationSettings

import DomainTesting
import RxBlocking
import XCTest

final class PushNotificationSettingsTests: XCTestCase {

    var sut: PushNotificationSettingsReactor!

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = .init(
            notificationsUseCase: NotificationsUseCaseMock(expectedAuthorizationStatus: .authorized),
            globalAction: .shared
        )
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
    }

    func test_reactorNeedsUpdate_whenDailyReminderIsSet() throws {
        // Common Given: DailyReminder 설정
        let notificationsUseCase: NotificationsUseCaseMock = .init(expectedAuthorizationStatus: .authorized)
        _ = try notificationsUseCase.requestNotificationAuthorization(with: [.alert, .sound])
            .toBlocking()
            .single()
        try notificationsUseCase.setDailyReminder(at: .init(hour: 11, minute: 22))
            .toBlocking()
            .single()

        // when authorized
        do {
            // Given
            sut = .init(notificationsUseCase: notificationsUseCase, globalAction: .shared)

            // When
            sut.action.onNext(.reactorNeedsUpdate)

            // Then
            XCTAssertEqual(sut.currentState.isOnDailyReminder, true)
            XCTAssertEqual(sut.currentState.reminderTime, .init(hour: 11, minute: 22))
        }

        // when not authorized
        do {
            // Given: 알림 거부 설정
            notificationsUseCase.expectedAuthorizationStatus = .denied
            _ = try notificationsUseCase.requestNotificationAuthorization(with: [.alert, .sound])
                .toBlocking()
                .single()
            sut = .init(notificationsUseCase: notificationsUseCase, globalAction: .shared)

            // When
            sut.action.onNext(.reactorNeedsUpdate)

            // Then
            XCTAssertEqual(sut.currentState.isOnDailyReminder, false)
            XCTAssertEqual(sut.currentState.reminderTime, .init(hour: 11, minute: 22))
        }
    }

    func test_turnOnOffDailyReminder_whenAuthorized() throws {
        // Given
        sut.action.onNext(.reactorNeedsUpdate)

        // On
        do {
            // When
            sut.action.onNext(.tapDailyReminderSwitch)

            // Then
            XCTAssertEqual(sut.currentState.isOnDailyReminder, true)
            XCTAssertNil(sut.currentState.needAuthAlert)
            XCTAssertNil(sut.currentState.moveToAuthSettingAlert)
        }

        // Off
        do {
            // When
            sut.action.onNext(.tapDailyReminderSwitch)

            // Then
            XCTAssertEqual(sut.currentState.isOnDailyReminder, false)
            XCTAssertNil(sut.currentState.needAuthAlert)
            XCTAssertNil(sut.currentState.moveToAuthSettingAlert)
        }
    }

    func test_turnOnOffDailyReminder_whenNotAuthorized() throws {
        // Given
        let notificationsUseCase: NotificationsUseCaseMock = .init(expectedAuthorizationStatus: .denied)
        _ = try notificationsUseCase.requestNotificationAuthorization(with: [.alert, .sound])
            .toBlocking()
            .single()
        sut = .init(notificationsUseCase: notificationsUseCase, globalAction: .shared)

        XCTAssertEqual(sut.currentState.isOnDailyReminder, false)
        XCTAssertNil(sut.currentState.moveToAuthSettingAlert)

        // When
        sut.action.onNext(.tapDailyReminderSwitch)

        // Then
        XCTAssertEqual(sut.currentState.isOnDailyReminder, false)
        XCTAssertNotNil(sut.currentState.moveToAuthSettingAlert) // Alert 표시됨
    }

    func test_turnOnOffDailyReminder_whenNotDetermined() throws {
        // Given
        let notificationsUseCase: NotificationsUseCaseMock = .init(expectedAuthorizationStatus: .notDetermined)
        sut = .init(notificationsUseCase: notificationsUseCase, globalAction: .shared)

        XCTAssertEqual(sut.currentState.isOnDailyReminder, false)
        XCTAssertNil(sut.currentState.needAuthAlert)

        // When
        sut.action.onNext(.tapDailyReminderSwitch)

        // Then
        XCTAssertEqual(sut.currentState.isOnDailyReminder, false)
        XCTAssertNotNil(sut.currentState.needAuthAlert)
    }

    func test_changeReminderTime() {
        // Given
        sut.action.onNext(.tapDailyReminderSwitch)
        XCTAssertEqual(sut.currentState.reminderTime, sut.initialState.reminderTime)

        // When
        let newTime = DateComponents(calendar: .current, hour: 11, minute: 22).date!
        sut.action.onNext(.changeReminderTime(newTime))

        // Then
        XCTAssertEqual(sut.currentState.reminderTime, DateComponents(hour: 11, minute: 22))
    }

    func test_sceneWillEnterForeground_whenAuthorizationChangesToDenied() throws {
        // Given
        let notificationsUseCase: NotificationsUseCaseMock = .init(expectedAuthorizationStatus: .authorized)
        _ = try notificationsUseCase.requestNotificationAuthorization(with: [.alert, .sound])
            .toBlocking()
            .single()
        try notificationsUseCase.setDailyReminder(at: .init(hour: 11, minute: 22))
            .toBlocking()
            .single()
        sut = .init(notificationsUseCase: notificationsUseCase, globalAction: .shared)
        sut.action.onNext(.reactorNeedsUpdate)

        XCTAssertEqual(sut.currentState.isOnDailyReminder, true)

        // When
        notificationsUseCase._authorizationStatus = .denied
        sut.globalAction.sceneWillEnterForeground.accept(())

        // Then
        XCTAssertEqual(sut.currentState.isOnDailyReminder, false)
        XCTAssertNotNil(sut.currentState.$needAuthAlert)
    }

}

// func test_() {
//    // Given
//
//
//    // When
//
//
//    // Then
//
// }
