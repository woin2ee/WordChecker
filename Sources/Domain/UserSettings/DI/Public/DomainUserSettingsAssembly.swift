//
//  DomainUserSettingsAssembly.swift
//  DataDriver
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import ExtendedUserDefaults
import Swinject

public final class DomainUserSettingsAssembly: Assembly {

    public init() {}
    
    public func assemble(container: Container) {
        container.register(UserSettingsService.self) { _ in
            let userDefaults: ExtendedUserDefaults = .standard
            return UserSettingsService(userDefaults: userDefaults)
        }
        .inObjectScope(.container)
    }
}
