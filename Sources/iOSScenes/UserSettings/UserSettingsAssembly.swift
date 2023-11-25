//
//  UserSettingsAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Swinject
import SwinjectExtension

public final class UserSettingsAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(UserSettingsViewController.self) { resolver in
            let userSettingsUseCase: UserSettingsUseCaseProtocol = resolver.resolve()
            let externalStoreUseCase: ExternalStoreUseCaseProtocol = resolver.resolve()
            let viewModel: UserSettingsViewModel = .init(userSettingsUseCase: userSettingsUseCase, googleDriveUseCase: externalStoreUseCase)

            return .init().then {
                $0.viewModel = viewModel
            }
        }
    }

}
