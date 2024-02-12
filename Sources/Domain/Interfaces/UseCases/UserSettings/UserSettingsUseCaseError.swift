//
//  UserSettingsUseCaseError.swift
//  Domain
//
//  Created by Jaewon Yun on 2/12/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation

public enum UserSettingsUseCaseError: Error {
    case noPendingDailyReminder
    case noNotificationAuthorization
}
