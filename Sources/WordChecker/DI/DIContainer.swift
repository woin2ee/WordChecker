//
//  DIContainer.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/27.
//

import Foundation
import Swinject

final class DIContainer {

    static let shared: DIContainer = .init()

    let assembler: Assembler

    private init() {
        self.assembler = .init([
            RealmPlatformAssembly(),
            UIViewControllerAssembly(),
            UseCaseAssembly(),
            UnmemorizedWordListStateAssembly()
        ])
    }

    func resolve<T>() -> T {
        return assembler.resolver.resolve(T.self)!
    }

    func resolve<T>(name: String) -> T {
        return assembler.resolver.resolve(T.self, name: name)!
    }

    func resolve<T, Arg1>(argument: Arg1) -> T {
        return assembler.resolver.resolve(T.self, argument: argument)!
    }

    func resolve<T, Arg1, Arg2>(arguments: Arg1, _ arg2: Arg2) -> T {
        return assembler.resolver.resolve(T.self, arguments: arguments, arg2)!
    }

}
