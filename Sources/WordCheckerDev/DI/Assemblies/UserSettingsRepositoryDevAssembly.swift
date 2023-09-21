//
//  UserSettingsRepositoryDevAssembly.swift
//  WordCheckerDev
//
//  Created by Jaewon Yun on 2023/09/21.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import iOSCore
import LaunchArguments
import Swinject
@testable import UserDefaultsPlatform

final class UserSettingsRepositoryDevAssembly: UserSettingsRepositoryAssembly {

    override func assemble(container: Container) {
        container.register(UserSettingsRepositoryProtocol.self) { _ in
            let userDefaults: WCUserDefaults = .init(_userDefaults: .init(suiteName: "Dev")!)

            let arguments = ProcessInfo.processInfo.arguments
            if arguments.contains(LaunchArguments.initUserDefaults.rawValue) {
                userDefaults.removeAllObject()
            }

            return UserSettingsRepository.init(userDefaults: userDefaults)
        }
    }

}
