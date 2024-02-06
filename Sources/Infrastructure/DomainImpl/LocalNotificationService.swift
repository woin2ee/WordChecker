//
//  LocalNotificationService.swift
//  Infrastructure
//
//  Created by Jaewon Yun on 2/6/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Domain
import ExtendedUserDefaults
import UserNotifications

final class LocalNotificationService: Domain.LocalNotificationService {

    let userDefaults: ExtendedUserDefaults
    let userNotificationCenter: UNUserNotificationCenter

    init(userDefaults: ExtendedUserDefaults, userNotificationCenter: UNUserNotificationCenter) {
        self.userDefaults = userDefaults
        self.userNotificationCenter = userNotificationCenter
    }

    func add(_ request: UNNotificationRequest) async throws {
        try await userNotificationCenter.add(request)
    }

    func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    func pendingNotificationRequests() async -> [UNNotificationRequest] {
        return await userNotificationCenter.pendingNotificationRequests()
    }

    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        return try await userNotificationCenter.requestAuthorization(options: options)
    }

    func notificationSettings() async -> UNNotificationSettings {
        return await userNotificationCenter.notificationSettings()
    }

    func saveLatestDailyReminderTime(_ time: DateComponents) throws {
        let result = userDefaults.setCodable(time, forKey: UserDefaultsKey.dailyReminderTime)
        try result.get()
    }

    func getLatestDailyReminderTime() throws -> DateComponents {
        let result = userDefaults.object(DateComponents.self, forKey: UserDefaultsKey.dailyReminderTime)
        return try result.get()
    }

}
