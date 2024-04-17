//
//  Created by Jaewon Yun on 2/6/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import ExtendedUserDefaults
import OSLog
import UserNotifications

final class DefaultLocalNotificationService: LocalNotificationService {

    private let userDefaults: ExtendedUserDefaults
    private let notificationCenter: UNUserNotificationCenter

    init(userDefaults: ExtendedUserDefaults, userNotificationCenter: UNUserNotificationCenter) {
        self.userDefaults = userDefaults
        self.notificationCenter = userNotificationCenter
    }

    func setDailyReminder(_ dailyReminder: DailyReminder) async throws {
        guard await notificationSettings().authorizationStatus == .authorized else {
            throw LocalNotificationServiceError.notificationNotAuthorized
        }

        let content: UNMutableNotificationContent = .init()
        content.title = LocalizedString.daily_reminder
        content.sound = .default
        content.userInfo = ["unmemorizedWordCount": dailyReminder.unmemorizedWordCount]

        if dailyReminder.unmemorizedWordCount == 0 {
            content.body = LocalizedString.daily_reminder_body_message_when_no_words_to_memorize
        } else {
            content.body = LocalizedString.daily_reminder_body_message(unmemorizedWordCount: dailyReminder.unmemorizedWordCount)
        }

        let noticeTime = DateComponents(hour: dailyReminder.noticeTime.hour, minute: dailyReminder.noticeTime.minute)
        let trigger: UNCalendarNotificationTrigger = .init(dateMatching: noticeTime, repeats: true)
        let notificationRequest: UNNotificationRequest = .init(
            identifier: DailyReminder.identifier,
            content: content,
            trigger: trigger
        )

        do {
            try saveLatestDailyReminderTime(dailyReminder.noticeTime)
        } catch {
            let logger = Logger(subsystem: "Service", category: "Service")
            logger.error("Not saved latest daily reminder time(\(dailyReminder.noticeTime.hour):\(dailyReminder.noticeTime.minute). \(error)")
        }

        try await notificationCenter.add(notificationRequest)
    }

    func removeDailyReminder() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [DailyReminder.identifier])
    }

    func getPendingDailyReminder() async -> DailyReminder? {
        let pendingNotifications = await notificationCenter.pendingNotificationRequests()

        guard let request = pendingNotifications
            .filter({ $0.identifier == DailyReminder.identifier })
            .first
        else {
            return nil
        }

        guard let hour = (request.trigger as? UNCalendarNotificationTrigger)?.dateComponents.hour,
              let minute = (request.trigger as? UNCalendarNotificationTrigger)?.dateComponents.minute,
              let unmemorizedWordCount = request.content.userInfo["unmemorizedWordCount"] as? Int else {
            return nil
        }

        return DailyReminder(
            unmemorizedWordCount: unmemorizedWordCount,
            noticeTime: NoticeTime(hour: hour, minute: minute)
        )
    }

    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        return try await notificationCenter.requestAuthorization(options: options)
    }

    func notificationSettings() async -> UNNotificationSettings {
        return await notificationCenter.notificationSettings()
    }

    func getLatestDailyReminderTime() throws -> NoticeTime {
        guard let latestDailyReminderTime = try? userDefaults.object(NoticeTime.self, forKey: UserDefaultsKey.dailyReminderTime).get() else {
            throw LocalNotificationServiceError.dailyReminderNeverSaved
        }
        return latestDailyReminderTime
    }
}

// MARK: Helpers

extension DefaultLocalNotificationService {

    /// Saves the latest time at which the daily reminder was set.
    ///
    /// - Parameter time: The time to be saved.
    /// - Throws: An error if the time cannot be saved.
    private func saveLatestDailyReminderTime(_ time: NoticeTime) throws {
        let result = userDefaults.setCodable(time, forKey: UserDefaultsKey.dailyReminderTime)
        try result.get()
    }
}
