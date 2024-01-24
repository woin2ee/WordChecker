//
//  NotificationsUseCaseAssembly.swift
//  Domain
//
//  Created by Jaewon Yun on 1/24/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation
import Swinject
import SwinjectExtension
import UserNotifications

final class NotificationsUseCaseAssembly: Assembly {

    func assemble(container: Container) {
        container.register(NotificationsUseCaseProtocol.self) { resolver in
            return NotificationsUseCase.init(
                notificationRepository: UNUserNotificationCenter.current(),
                wordRepository: resolver.resolve(),
                userSettingsRepository: resolver.resolve()
            )
        }
        .inObjectScope(.container)
    }

}
