//
//  LocalNotificationsUseCaseAssembly.swift
//  Domain
//
//  Created by Jaewon Yun on 1/24/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation
import Swinject
import SwinjectExtension

public final class LocalNotificationsUseCaseAssembly: Assembly {

    public init() {}
    
    public func assemble(container: Container) {
        container.register(NotificationsUseCaseProtocol.self) { resolver in
            return NotificationsUseCase(
                localNotificationService: resolver.resolve(),
                wordService: resolver.resolve()
            )
        }
        .inObjectScope(.container)
    }
}
