//
//  GeneralSettingsAssembly.swift
//  GeneralSettings
//
//  Created by Jaewon Yun on 1/25/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import IOSSupport
import Swinject
import SwinjectExtension
import Then

internal final class GeneralSettingsAssembly: Assembly {

    func assemble(container: Container) {
        container.register(GeneralSettingsReactor.self) { resolver in
            return .init(
                userSettingsUseCase: resolver.resolve(),
                globalState: GlobalState.shared
            )
        }

        container.register(GeneralSettingsViewControllerProtocol.self) { resolver in
            return GeneralSettingsViewController().then {
                $0.reactor = resolver.resolve()
            }
        }
    }

}
