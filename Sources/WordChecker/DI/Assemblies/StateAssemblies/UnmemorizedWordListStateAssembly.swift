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

final class UnmemorizedWordListStateAssembly: Assembly {

    func assemble(container: Container) {
        container.register(UnmemorizedWordListStateProtocol.self) { _ in
            return UnmemorizedWordListState.init()
        }
        .inObjectScope(.container)
    }

}
