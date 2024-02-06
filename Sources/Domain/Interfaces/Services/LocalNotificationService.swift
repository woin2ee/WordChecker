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
///
/// 이 프로토콜의 구현으로는 `UserNotifications.UNUserNotificationCenter.current()` 가 사용됩니다.
public protocol LocalNotificationService {
    func add(_ request: UNNotificationRequest) async throws
    func removePendingNotificationRequests(withIdentifiers identifiers: [String])
    func pendingNotificationRequests() async -> [UNNotificationRequest]
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool
    func notificationSettings() async -> UNNotificationSettings
}
