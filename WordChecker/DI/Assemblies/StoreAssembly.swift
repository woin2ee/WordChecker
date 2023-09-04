//
//  StoreAssembly.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/03.
//

import Foundation
import ReSwift
import Swinject

final class StoreAssembly: Assembly {

    func assemble(container: Container) {
        container.register(StateStore.self) { _ in
            return .init(reducer: AppState.reducer, state: nil)
        }
        .inObjectScope(.container)
    }

}
