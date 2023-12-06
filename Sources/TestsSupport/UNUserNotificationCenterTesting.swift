//
//  UNUserNotificationCenterTesting.swift
//  DomainTests
//
//  Created by Jaewon Yun on 12/6/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import Domain

import Foundation
import UserNotifications

public final class UNUserNotificationCenterFake: UserNotificationCenter {

    public var _pendingNotifications: [UNNotificationRequest] = []

    public init() {

    }

    public func add(_ request: UNNotificationRequest) async throws {
        _pendingNotifications.append(request)
    }

    public func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        identifiers.forEach { identifier in
            self._pendingNotifications.removeAll(where: { $0.identifier == identifier })
        }
    }

}
