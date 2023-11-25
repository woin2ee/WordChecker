@testable import WCNotificationCenter

import XCTest

final class WCNotificationCenterTests: XCTestCase {

    var sut: WCNotificationCenterProtocol!
    var delegateSpy: DelegateMock!

    override func setUp() async throws {
        try await super.setUp()

        sut = WCNotificationCenter.init(notificationCenter: .current())
        delegateSpy = await .init()

        let isAuthorized = try await sut.requestAuthorization(options: .alert)
        XCTAssertTrue(isAuthorized)
    }

    override func tearDown() async throws {
        try await super.tearDown()

        sut.removeAllPendingNotifications()

        sut = nil
        delegateSpy = nil
    }

    func test_addLocalNotification() async throws {
        // Given

        // When
        try await sut.addNotification(identifier: "Test")

        // Then
        let notifications = await sut.getAllPendingNotifications()
        XCTAssertEqual(notifications.count, 1)
        XCTAssertTrue(notifications.contains(where: { $0.identifier == "Test" }))
    }

    func test_removePendingNotification() async throws {
        // Given
        try await sut.addNotification(identifier: "Test")

        // When
        sut.removePendingNotification(withIdentifier: "Test")

        // Then
        let notifications = await sut.getAllPendingNotifications()
        XCTAssertEqual(notifications.count, 0)
    }

    func test_() {
        // Given

        // When

        // Then

    }

}

// MARK: Template

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
