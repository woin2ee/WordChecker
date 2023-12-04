//
//  PushNotificationSettingsAssembly.swift
//  PushNotificationSettings
//
//  Created by Jaewon Yun on 11/29/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import Swinject
import SwinjectExtension
import Then

public final class PushNotificationSettingsAssembly: Assembly {

    public func assemble(container: Container) {
        container.register(PushNotificationSettingsReactor.self) { _ in
            return .init()
        }

        container.register(PushNotificationSettingsViewController.self) { resolver in
            let reactor: PushNotificationSettingsReactor = resolver.resolve()

            return .init().then {
                $0.reactor = reactor
            }
        }
    }

}
