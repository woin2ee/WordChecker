//
//  UserSettingsAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import IOSSupport
import Swinject
import SwinjectExtension
import Then

public final class UserSettingsAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(UserSettingsReactor.self) { resolver in
            return .init(
                userSettingsUseCase: resolver.resolve(),
                googleDriveUseCase: resolver.resolve(),
                globalAction: GlobalAction.shared
            )
        }

        container.register(UserSettingsViewControllerProtocol.self) { resolver in
            return UserSettingsViewController.init().then {
                $0.reactor = resolver.resolve()
            }
        }
    }

}
