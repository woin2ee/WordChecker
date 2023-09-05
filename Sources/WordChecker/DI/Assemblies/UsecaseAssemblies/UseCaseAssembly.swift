//
//  UseCaseAssembly.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/09/05.
//

import Domain
import Foundation
import Swinject

final class UseCaseAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WordUseCaseProtocol.self) { resolver in
            let repository: WordRepositoryProtocol = resolver.resolve()
            return WordUseCase.init(wordRepository: repository)
        }
        .inObjectScope(.container)
    }

}
