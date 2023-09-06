//
//  StoreAssembly.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/03.
//

import StateStore
import Swinject

final class StoreAssembly: Assembly {

    func assemble(container: Container) {
        container.register(StateStore.self) { resolver in
            let reducer: AppState.Reducer = resolver.resolve()
            return .init(reducer: reducer.createNewState, state: nil)
        }
        .inObjectScope(.container)
    }

}
