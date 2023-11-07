//
//  UserSettingsViewControllerAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/10/01.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Swinject

final class UserSettingsViewControllerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(UserSettingsViewController.self) { resolver in
            let userSettingsUseCase: UserSettingsUseCaseProtocol = resolver.resolve()
            let externalStoreUseCase: ExternalStoreUseCaseProtocol = resolver.resolve()
            let viewModel: UserSettingsViewModel = .init(userSettingsUseCase: userSettingsUseCase, googleDriveUseCase: externalStoreUseCase)
            let viewController: UserSettingsViewController = .init(viewModel: viewModel)
            return viewController
        }
    }

}
