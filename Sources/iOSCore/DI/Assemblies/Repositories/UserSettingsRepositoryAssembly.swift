//
//  RepositoryAssemblies.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/18.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import DataDriver
import Domain
import Foundation
import Swinject

open class UserSettingsRepositoryAssembly: Assembly {

    public init() {}

    open func assemble(container: Container) {
        container.register(UserSettingsRepositoryProtocol.self) { _ in
            let userDefaults: WCUserDefaults = .init(_userDefaults: .standard)
            return UserSettingsRepository.init(userDefaults: userDefaults)
        }
    }

}
