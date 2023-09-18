//
//  DIContainer.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/27.
//

import Foundation
import Swinject

public final class DIContainer {

    public static let shared: DIContainer = .init()

    public let assembler: Assembler

    private init() {
        self.assembler = .init([
            UIViewControllerAssembly(),
            UseCaseAssembly(),
            UnmemorizedWordListStateAssembly(),
            RepositoryAssemblies(),
        ])
    }

    public func resolve<T>() -> T {
        return assembler.resolver.resolve(T.self)!
    }

    public func resolve<T>(name: String) -> T {
        return assembler.resolver.resolve(T.self, name: name)!
    }

    public func resolve<T, Arg1>(argument: Arg1) -> T {
        return assembler.resolver.resolve(T.self, argument: argument)!
    }

    public func resolve<T, Arg1, Arg2>(arguments: Arg1, _ arg2: Arg2) -> T {
        return assembler.resolver.resolve(T.self, arguments: arguments, arg2)!
    }

}
