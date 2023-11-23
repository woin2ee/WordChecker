//
//  LanguageSettingAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Swinject
import SwinjectExtension
import Then

public final class LanguageSettingAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(LanguageSettingViewController.self) { resolver, settingsDirection, currentSettingLocale in
            let userSettingsUseCase: UserSettingsUseCaseProtocol = resolver.resolve()
            let viewModel: LanguageSettingViewModel = .init(userSettingsUseCase: userSettingsUseCase, settingsDirection: settingsDirection, currentSettingLocale: currentSettingLocale)

            return .init().then {
                $0.viewModel = viewModel
            }
        }
    }

}
