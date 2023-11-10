//
//  WordListReactorAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/10.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import Swinject

final class WordListReactorAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WordListReactor.self) { resolver in
            let wordUseCase: WordRxUseCaseProtocol = resolver.resolve()

            return .init(globalAction: .shared, wordUseCase: wordUseCase)
        }
    }

}
