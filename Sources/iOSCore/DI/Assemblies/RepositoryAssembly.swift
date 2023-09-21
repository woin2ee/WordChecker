//
//  RepositoryAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/21.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import Swinject

public final class RepositoryAssembly: Assembly {

    let userSettingsRepositoryAssembly: UserSettingsRepositoryAssembly
    let wordRepositoryAssembly: WordRepositoryAssembly

    public init(
        userSettingsRepositoryAssembly: UserSettingsRepositoryAssembly = .init(),
        wordRepositoryAssembly: WordRepositoryAssembly = .init()
    ) {
        self.userSettingsRepositoryAssembly = userSettingsRepositoryAssembly
        self.wordRepositoryAssembly = wordRepositoryAssembly
    }

    public func assemble(container: Container) {
        let assemblies: [Assembly] = [
            userSettingsRepositoryAssembly,
            wordRepositoryAssembly,
            UnmemorizedWordListStateAssembly(),
        ]

        assemblies.forEach { assembly in
            assembly.assemble(container: container)
        }
    }

}
