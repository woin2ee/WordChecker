//
//  UnmemorizedWordListStateAssembly.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/06.
//

import Domain
import Foundation
import State
import Swinject

public final class UnmemorizedWordListStateAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(UnmemorizedWordListStateProtocol.self) { _ in
            return UnmemorizedWordListState.init()
        }
        .inObjectScope(.container)
    }

}
