//
//  ReactorsAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/07.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import Swinject

public final class ReactorsAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        let assemblies: [Assembly] = [
            WordCheckingReactorAssembly(),
            WordDetailReactorAssembly(),
        ]

        assemblies.forEach { assembly in
            assembly.assemble(container: container)
        }
    }

}
