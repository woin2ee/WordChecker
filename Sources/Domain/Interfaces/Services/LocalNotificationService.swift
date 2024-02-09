//
//  UserNotificationRepository.swift
//  Domain
//
//  Created by Jaewon Yun on 1/23/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation
import UserNotifications

/// The service for local notification.
public protocol LocalNotificationService {

    func add(_ request: UNNotificationRequest) async throws

    func removePendingNotificationRequests(withIdentifiers identifiers: [String])

    func pendingNotificationRequests() async -> [UNNotificationRequest]

    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool

    func notificationSettings() async -> UNNotificationSettings

    /// 매일 알림을 설정한 마지막 시각을 저장합니다.
    ///
    /// - throws: 정상적으로 저장하지 못했을 때 Error 를 던집니다.
    func saveLatestDailyReminderTime(_ time: DateComponents) throws

    /// 매일 알림을 설정한 마지막 시각을 반환합니다.
    ///
    /// /// - throws: 저장된 시각이 없을 때 Error 를 던집니다.
    func getLatestDailyReminderTime() throws -> DateComponents
}
