//
//  ReducerAssembly.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/05.
//

import Domain
import Foundation
import StateStore
import Swinject

final class ReducerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(AppState.Reducer.self) { resolver in
            let wordStateReducer: WordState.Reducer = resolver.resolve()
            return AppState.Reducer.init(wordStateReducer: wordStateReducer)
        }
        .inObjectScope(.container)
        container.register(WordState.Reducer.self) { resolver in
            let wordUseCase: WordUseCaseProtocol = resolver.resolve()
            return WordState.Reducer.init(wordUseCase: wordUseCase)
        }
        .inObjectScope(.container)
    }

}
