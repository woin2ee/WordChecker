//
//  UserSettingsUseCaseAssembly.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Swinject
import SwinjectExtension

final class UserSettingsUseCaseAssembly: Assembly {

    func assemble(container: Container) {
        container.register(UserSettingsUseCaseProtocol.self) { resolver in
            return UserSettingsUseCase.init(userSettingsRepository: resolver.resolve())
        }
        .inObjectScope(.container)
    }

}
