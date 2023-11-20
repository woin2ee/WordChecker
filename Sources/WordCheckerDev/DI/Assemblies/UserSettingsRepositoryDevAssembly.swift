//
//  UserSettingsRepositoryDevAssembly.swift
//  WordCheckerDev
//
//  Created by Jaewon Yun on 2023/09/21.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import DataDriver
import Domain
import DIContainer
import ExtendedUserDefaults
import Foundation
import iOSCore
import iPhoneDriver
import Swinject
import Testing

final class UserSettingsRepositoryDevAssembly: UserSettingsRepositoryAssembly {

    override func assemble(container: Container) {
        container.register(UserSettingsRepositoryProtocol.self) { _ in
            let userDefaults: ExtendedUserDefaults = .init(suiteName: "Dev")!
            let arguments = ProcessInfo.processInfo.arguments
            if arguments.contains(LaunchArguments.initUserDefaults.rawValue) {
                userDefaults.removeAllObject(forKeyType: UserDefaultsKey.self)
            }

            return UserSettingsRepository.init(userDefaults: userDefaults)
        }
        .inObjectScope(.container)
    }

}
