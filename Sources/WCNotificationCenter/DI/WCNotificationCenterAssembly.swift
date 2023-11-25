//
//  WCNotificationCenterAssembly.swift
//  WCNotificationCenter
//
//  Created by Jaewon Yun on 11/26/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import Swinject

public final class WCNotificationCenterAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(WCNotificationCenterProtocol.self) { _ in
            return WCNotificationCenter.init(notificationCenter: .current())
        }
    }

}

