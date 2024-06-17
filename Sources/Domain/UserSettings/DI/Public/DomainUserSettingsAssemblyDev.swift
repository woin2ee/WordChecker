//
//  DomainUserSettingsAssemblyDev.swift
//  WordCheckerDev
//
//  Created by Jaewon Yun on 2023/09/21.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import ExtendedUserDefaults
import Foundation
import Swinject
import UtilitySource

public final class DomainUserSettingsAssemblyDev: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(UserSettingsService.self) { _ in
            let userDefaults: ExtendedUserDefaults = .init(suiteName: "Dev")!

            LaunchArgument.verify()

            if LaunchArgument.contains(.initUserDefaults) {
                userDefaults.removeAllObject(forKeyType: UserDefaultsKey.self)
            }

            return UserDefaultsUserSettingsService(userDefaults: userDefaults)
        }
        .inObjectScope(.container)
    }
}
