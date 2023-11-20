//
//  UserSettingsUseCaseAssembly.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Swinject
import SwinjectExtension

final class UserSettingsUseCaseAssembly: Assembly {

    func assemble(container: Container) {
        container.register(UserSettingsUseCaseProtocol.self) { resolver in
            let userSettingsRepository: UserSettingsRepositoryProtocol = resolver.resolve()
            return UserSettingsUseCase.init(userSettingsRepository: userSettingsRepository)
        }
        .inObjectScope(.container)
    }

}
