//
//  UserSettingsUseCaseAssembly.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Swinject
import SwinjectExtension

public final class UserSettingsUseCaseAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(UserSettingsUseCase.self) { resolver in
            return DefaultUserSettingsUseCase(userSettingsService: resolver.resolve())
        }
        .inObjectScope(.container)
    }
}
