//
//  StateAssembly.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/03.
//

import Foundation
import ReSwift
import Swinject

final class StateAssembly: Assembly {

    func assemble(container: Container) {
        container.register(AppStore.self) { _ in
            return .init(reducer: AppState.reducer, state: nil)
        }
        .inObjectScope(.container)
    }

}
