//
//  UserSettingsRepositoryAssemblyDev.swift
//  WordCheckerDev
//
//  Created by Jaewon Yun on 2023/09/21.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import ExtendedUserDefaults
import Foundation
import Swinject
import Utility

final class UserSettingsRepositoryAssemblyDev: Assembly {

    func assemble(container: Container) {
        container.register(UserSettingsRepositoryProtocol.self) { _ in
            let userDefaults: ExtendedUserDefaults = .init(suiteName: "Dev")!

            LaunchArgument.verify()

            if LaunchArgument.contains(.initUserDefaults) {
                userDefaults.removeAllObject(forKeyType: UserDefaultsKey.self)
            }

            return UserSettingsRepository.init(userDefaults: userDefaults)
        }
        .inObjectScope(.container)
    }

}
