//
//  LocalNotificationService.swift
//  Domain_LocalNotification
//
//  Created by Jaewon Yun on 3/28/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import UserNotifications

/// A protocol defining the interface for managing local notifications.
public protocol LocalNotificationService {
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
