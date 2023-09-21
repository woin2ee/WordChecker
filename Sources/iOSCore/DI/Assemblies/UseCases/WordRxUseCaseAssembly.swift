//
//  UseCaseAssembly.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/05.
//

import Domain
import Foundation
import Swinject

public final class WordRxUseCaseAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(WordRxUseCaseProtocol.self) { resolver in
            let wordUseCase: WordUseCaseProtocol = resolver.resolve()
            return WordRxUseCase.init(wordUseCase: wordUseCase)
        }
        .inObjectScope(.container)
    }

}
