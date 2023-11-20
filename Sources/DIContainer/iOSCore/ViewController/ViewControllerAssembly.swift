//
//  ViewControllerAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/10/01.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Swinject

public final class ViewControllerAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        let assemblies: [Assembly] = [
            WordCheckingViewControllerAssembly(),
            WordListViewControllerAssembly(),
            WordDetailViewControllerAssembly(),
            WordAdditionViewControllerAssembly(),
            UserSettingsViewControllerAssembly(),
            LanguageSettingViewControllerAssembly(),
        ]

        assemblies.forEach { assembly in
            assembly.assemble(container: container)
        }
    }

}
