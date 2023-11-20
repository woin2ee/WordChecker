//
//  WordUseCaseAssembly.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Swinject
import SwinjectExtension

final class WordUseCaseAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WordUseCaseProtocol.self) { resolver in
            let wordRepository: WordRepositoryProtocol = resolver.resolve()
            let unmemorizedWordListRepository: UnmemorizedWordListRepositoryProtocol = resolver.resolve()

            return WordUseCase.init(
                wordRepository: wordRepository,
                unmemorizedWordListRepository: unmemorizedWordListRepository
            )
        }
        .inObjectScope(.container)
    }

}
