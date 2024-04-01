//
//  LocalNotificationServiceDummy.swift
//  Domain_LocalNotificationTesting
//
//  Created by Jaewon Yun on 3/28/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Domain_LocalNotification
import Foundation
import UserNotifications

public final class LocalNotificationServiceDummy: LocalNotificationService {

    public init() {}

    public func setDailyReminder(_ dailyReminder: Domain_LocalNotification.DailyReminder) async throws {
    }

    public func removeDailyReminder() {
    }

    public func getPendingDailyReminder() async -> Domain_LocalNotification.DailyReminder? {
        return nil
    }

    public func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        return true
    }

    public func notificationSettings() async -> UNNotificationSettings {
        let coder: NotificationSettingsCoder = .init()
        coder.authorizationStatus = .authorized
        return UNNotificationSettings(coder: coder)!
    }

    public func getLatestDailyReminderTime() throws -> Domain_LocalNotification.NoticeTime {
        return .init(hour: 0, minute: 0)
    }
}
