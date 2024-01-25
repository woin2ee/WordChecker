//
//  GeneralSettingsAssembly.swift
//  GeneralSettings
//
//  Created by Jaewon Yun on 1/25/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Domain
import Swinject
import SwinjectExtension
import Then

public final class GeneralSettingsAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(GeneralSettingsViewControllerProtocol.self) { resolver in
            return GeneralSettingsViewController().then {
                $0.reactor = resolver.resolve()
            }
        }
    }

}
