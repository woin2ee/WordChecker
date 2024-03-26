//
//  LanguageSettingAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import IOSSupport
import Swinject
import SwinjectExtension
import Then

public final class LanguageSettingAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(LanguageSettingViewControllerProtocol.self) { resolver, translationDirection in
            let reactor: LanguageSettingReactor = .init(
                translationDirection: translationDirection,
                userSettingsUseCase: resolver.resolve(),
                globalAction: GlobalAction.shared
            )

            return LanguageSettingViewController.init().then {
                $0.reactor = reactor
            }
        }
    }

}
