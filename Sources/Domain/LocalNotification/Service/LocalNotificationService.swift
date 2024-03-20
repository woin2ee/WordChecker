//
//  LocalNotificationService.swift
//  Infrastructure
//
//  Created by Jaewon Yun on 2/6/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import ExtendedUserDefaults
import OSLog
import UserNotifications

/// A protocol defining the interface for managing local notifications.
public protocol LocalNotificationServiceProtocol {
    /// Sets a daily reminder notification.
    ///
    /// If you already have a daily reminder set, it will be replaced with the new daily reminder.
    /// - Parameters:
    ///   - dailyReminder: The daily reminder to be set.
    func setDailyReminder(_ dailyReminder: DailyReminder) async throws
    
    /// Removes the daily reminder notification.
    func removeDailyReminder()
    
    /// Retrieves the pending daily reminder notification.
    ///
    /// - Returns: The pending daily reminder if found, otherwise nil.
    func getPendingDailyReminder() async -> DailyReminder?
    
    /// Requests authorization for sending notifications with specified options.
    ///
    /// - Parameter options: The options for notification authorization.
    /// - Returns: A boolean value indicating if the authorization request was successful.
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool
    
    /// Retrieves the current notification settings.
    ///
    /// - Returns: The notification settings.
    func notificationSettings() async -> UNNotificationSettings
    
    /// Retrieves the latest time at which the daily reminder was set.
    ///
    /// - Returns: The latest time of the daily reminder.
    /// - Throws: An error if the time cannot be retrieved.
    func getLatestDailyReminderTime() throws -> NoticeTime
}

final class LocalNotificationService: LocalNotificationServiceProtocol {

    let userDefaults: ExtendedUserDefaults
    let notificationCenter: UNUserNotificationCenter

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
        let result = userDefaults.object(NoticeTime.self, forKey: UserDefaultsKey.dailyReminderTime)
        return try result.get()
    }
}

// MARK: Helpers

extension LocalNotificationService {
    
    /// Saves the latest time at which the daily reminder was set.
    ///
    /// - Parameter time: The time to be saved.
    /// - Throws: An error if the time cannot be saved.
    private func saveLatestDailyReminderTime(_ time: NoticeTime) throws {
        let result = userDefaults.setCodable(time, forKey: UserDefaultsKey.dailyReminderTime)
        try result.get()
    }
}
