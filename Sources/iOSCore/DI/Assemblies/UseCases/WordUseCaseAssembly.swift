//
//  WordUseCaseAssembly.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/05.
//

import Domain
import Foundation
import Swinject

public final class WordUseCaseAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
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
