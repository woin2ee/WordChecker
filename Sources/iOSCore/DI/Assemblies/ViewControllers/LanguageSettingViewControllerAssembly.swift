//
//  LanguageSettingViewControllerAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/10/01.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Swinject

final class LanguageSettingViewControllerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(LanguageSettingViewController.self) { resolver, settingsDirection, currentSettingLocale in
            let userSettingsUseCase: UserSettingsUseCaseProtocol = resolver.resolve()
            let viewModel: LanguageSettingViewModel = .init(userSettingsUseCase: userSettingsUseCase, settingsDirection: settingsDirection, currentSettingLocale: currentSettingLocale)
            let viewController: LanguageSettingViewController = .init(viewModel: viewModel)
            return viewController
        }
    }

}
