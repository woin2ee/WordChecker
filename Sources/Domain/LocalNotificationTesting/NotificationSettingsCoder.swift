//
//  NotificationSettingsCoder.swift
//  Domain_LocalNotificationTesting
//
//  Created by Jaewon Yun on 3/28/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation
import UserNotifications

internal final class NotificationSettingsCoder: NSCoder {

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
