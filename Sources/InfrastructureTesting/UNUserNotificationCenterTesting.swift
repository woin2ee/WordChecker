//
//  UNUserNotificationCenterTesting.swift
//  DomainTests
//
//  Created by Jaewon Yun on 12/6/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import Domain

import Foundation
import UserNotifications

public final class LocalNotificationServiceFake: LocalNotificationService {

    public var _authorizationStatus: UNAuthorizationStatus = .notDetermined
    public var _pendingNotifications: [UNNotificationRequest] = []
    public var _latestDailyReminderTime: DateComponents?

    public init() {

    }

    public func add(_ request: UNNotificationRequest) async throws {
        if let duplicatedIDIndex = _pendingNotifications.firstIndex(where: { $0.identifier == request.identifier }) {
            _pendingNotifications[duplicatedIDIndex] = request
            return
        }

        _pendingNotifications.append(request)
    }

    public func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        identifiers.forEach { identifier in
            self._pendingNotifications.removeAll(where: { $0.identifier == identifier })
        }
    }

    public func pendingNotificationRequests() async -> [UNNotificationRequest] {
        return _pendingNotifications
    }

    public func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        _authorizationStatus = .authorized
        return true
    }

    public func notificationSettings() async -> UNNotificationSettings {
        let coder: NotificationSettingsCoder = .init()
        coder.authorizationStatus = _authorizationStatus
        return UNNotificationSettings(coder: coder)!
    }

    public func saveLatestDailyReminderTime(_ time: DateComponents) throws {
        _latestDailyReminderTime = time
    }

    public func getLatestDailyReminderTime() throws -> DateComponents {
        guard let latestDailyReminderTime = _latestDailyReminderTime else {
            throw UserSettingsRepositoryError.notSavedLatestDailyReminderTime
        }

        return latestDailyReminderTime
    }

}

private final class NotificationSettingsCoder: NSCoder {

    var authorizationStatus: UNAuthorizationStatus!

    override func decodeInteger(forKey key: String) -> Int {
        if key == "authorizationStatus" {
            return authorizationStatus.rawValue
        }

        return -1
    }

    override func decodeBool(forKey key: String) -> Bool {
        return false
    }

}
