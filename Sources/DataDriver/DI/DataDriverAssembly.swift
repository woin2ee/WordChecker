//
//  DataDriverAssembly.swift
//  DataDriver
//
//  Created by Jaewon Yun on 2023/11/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Swinject

public final class DataDriverAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        let assemblies: [Assembly] = [
            UserSettingsRepositoryAssembly(),
            WordRepositoryAssembly(),
            UnmemorizedWordListRepositoryAssembly(),
            GoogleDriveRepositoryAssembly(),
        ]

        assemblies.forEach { assembly in
            assembly.assemble(container: container)
        }
    }

}
