//
//  Resolver+resolve.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/03.
//

import Foundation
import Swinject

extension Resolver {

    func resolve<T>() -> T {
        guard let resolved = self.resolve(T.self) else {
            fatalError("Failed to resolve for '\(T.self)' type.")
        }
        return resolved
    }

    func resolve<T, Arg1>(argument: Arg1) -> T {
        guard let resolved = self.resolve(T.self, argument: argument) else {
            fatalError("Failed to resolve for '\(T.self)' type with [\(argument)].")
        }
        return resolved
    }
    
    func resolve<T, Arg1, Arg2>(arguments arg1: Arg1, _ arg2: Arg2) -> T {
        guard let resolved = self.resolve(T.self, arguments: arg1, arg2) else {
            fatalError("Failed to resolve for '\(T.self)' type with [\(arg1), \(arg2)].")
        }
        return resolved
    }

}
