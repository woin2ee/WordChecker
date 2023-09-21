//
//  UseCaseAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/21.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import Swinject

public final class UseCaseAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        let assemblies: [Assembly] = [
            WordUseCaseAssembly(),
            WordRxUseCaseAssembly(),
            UserSettingsUseCaseAssembly(),
        ]

        assemblies.forEach { assembly in
            assembly.assemble(container: container)
        }
    }

}
