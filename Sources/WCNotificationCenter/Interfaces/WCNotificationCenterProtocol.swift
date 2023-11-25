//
//  WCNotificationCenterProtocol.swift
//  WCNotificationCenter
//
//  Created by Jaewon Yun on 11/24/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import UserNotifications

public protocol WCNotificationCenterProtocol {

    var delegate: UNUserNotificationCenterDelegate? { get set }

    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool

    func addNotification(identifier: String) async throws

    func getAllPendingNotifications() async -> [UNNotificationRequest]

    func getAllDeliveredNotifications() async -> [UNNotification]

    func removePendingNotification(withIdentifier identifier: String)

    func removeAllPendingNotifications()

}
