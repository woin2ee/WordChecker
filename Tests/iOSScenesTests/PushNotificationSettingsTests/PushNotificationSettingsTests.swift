@testable import PushNotificationSettings

import DomainTesting
import RxBlocking
import XCTest

final class PushNotificationSettingsTests: XCTestCase {

    var sut: PushNotificationSettingsReactor!

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = .init(userSettingsUseCase: UserSettingsUseCaseFake())
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
    }

    func test_viewDidLoad_whenDailyReminderIsSet() throws {
        // Given
        let userSettingsUseCase: UserSettingsUseCaseFake = .init()
        try userSettingsUseCase.setDailyReminder(at: .init(hour: 11, minute: 22))
            .toBlocking()
            .single()
        sut = .init(userSettingsUseCase: userSettingsUseCase)

        // When
        sut.action.onNext(.viewDidLoad)

        // Then
        XCTAssertEqual(sut.currentState.isOnDailyReminder, true)
        XCTAssertEqual(sut.currentState.reminderTime, .init(hour: 11, minute: 22))
    }

    func test_turnOnOffDailyReminder() {
        // On
        do {
            // When
            sut.action.onNext(.onDailyReminder)

            // Then
            XCTAssertEqual(sut.currentState.isOnDailyReminder, true)
        }

        // Off
        do {
            // When
            sut.action.onNext(.offDailyReminder)

            // Then
            XCTAssertEqual(sut.currentState.isOnDailyReminder, false)
        }
    }

    func test_changeReminderTime() {
        // Given
        sut.action.onNext(.onDailyReminder)
        XCTAssertEqual(sut.currentState.reminderTime, sut.initialState.reminderTime)

        // When
        let newTime = DateComponents(calendar: .current, hour: 11, minute: 22).date!
        sut.action.onNext(.changeReminderTime(newTime))

        // Then
        XCTAssertEqual(sut.currentState.reminderTime, DateComponents(hour: 11, minute: 22))
    }

}
