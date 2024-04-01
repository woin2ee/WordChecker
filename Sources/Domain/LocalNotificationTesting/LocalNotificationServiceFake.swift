//
//  Created by Jaewon Yun on 12/6/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import Domain_LocalNotification
import Foundation
import UserNotifications

public final class LocalNotificationServiceFake: LocalNotificationService {

    var authorizationStatus: UNAuthorizationStatus = .notDetermined
    var pendingDailyReminder: DailyReminder?
    var latestDailyReminderTime: NoticeTime?

    public init() {}

    public func setDailyReminder(_ dailyReminder: Domain_LocalNotification.DailyReminder) async throws {
        guard authorizationStatus == .authorized else {
            throw LocalNotificationServiceError.notificationNotAuthorized
        }

        pendingDailyReminder = dailyReminder
        latestDailyReminderTime = dailyReminder.noticeTime
    }

    public func removeDailyReminder() {
        pendingDailyReminder = nil
    }

    public func getPendingDailyReminder() async -> Domain_LocalNotification.DailyReminder? {
        return pendingDailyReminder
    }

    public func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        authorizationStatus = .authorized
        return true
    }

    public func notificationSettings() async -> UNNotificationSettings {
        let coder: NotificationSettingsCoder = .init()
        coder.authorizationStatus = authorizationStatus
        return UNNotificationSettings(coder: coder)!
    }

    public func getLatestDailyReminderTime() throws -> Domain_LocalNotification.NoticeTime {
        guard let latestDailyReminderTime = latestDailyReminderTime else {
            throw LocalNotificationServiceError.dailyReminderNeverSaved
        }
        return latestDailyReminderTime
    }
}
