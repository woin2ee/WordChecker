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
        container.register(AppStateReducer.self) { resolver in
            let wordStateReducer: WordStateReducer = resolver.resolve()
            return AppStateReducer.init(wordStateReducer: wordStateReducer)
        }
        .inObjectScope(.container)
        container.register(WordStateReducer.self) { resolver in
            let wordUseCase: WordUseCaseProtocol = resolver.resolve()
            return WordStateReducer.init(wordUseCase: wordUseCase)
        }
        .inObjectScope(.container)
    }

}
