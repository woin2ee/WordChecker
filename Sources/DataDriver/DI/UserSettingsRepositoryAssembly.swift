//
//  UserSettingsRepositoryAssembly.swift
//  DataDriver
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import ExtendedUserDefaults
import Swinject

open class UserSettingsRepositoryAssembly: Assembly {

    public init() {}

    open func assemble(container: Container) {
        container.register(UserSettingsRepositoryProtocol.self) { _ in
            let userDefaults: ExtendedUserDefaults = .standard
            return UserSettingsRepository.init(userDefaults: userDefaults)
        }
        .inObjectScope(.container)
    }

}
