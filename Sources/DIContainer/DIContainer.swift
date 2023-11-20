//
//  DIContainer.swift
//  DIContainer
//
//  Created by Jaewon Yun on 2023/11/21.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Swinject

public class DIContainer {

    public static let shared: DIContainer = .init(assembler: .init([
        RepositoryAssembly(),
        UseCaseAssembly(),
        ReactorsAssembly(),
        ViewControllerAssembly(),
    ]))

    /// An assembler used to resolve service.
    public var assembler: Assembler

    public var resolver: Resolver {
        self.assembler.resolver
    }

    private init(assembler: Assembler) {
        self.assembler = assembler
    }

}
