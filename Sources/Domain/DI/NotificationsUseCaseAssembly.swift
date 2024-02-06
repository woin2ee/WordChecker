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

final class NotificationsUseCaseAssembly: Assembly {

    func assemble(container: Container) {
        container.register(NotificationsUseCaseProtocol.self) { resolver in
            return NotificationsUseCase.init(
                localNotificationService: resolver.resolve(),
                wordRepository: resolver.resolve(),
                userSettingsRepository: resolver.resolve()
            )
        }
        .inObjectScope(.container)
    }

}
