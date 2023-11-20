//
//  WordRxUseCaseAssembly.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Swinject
import SwinjectExtension

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
