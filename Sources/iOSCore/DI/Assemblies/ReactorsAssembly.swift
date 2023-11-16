//
//  ReactorsAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/07.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import Swinject

public final class ReactorsAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        let assemblies: [Assembly] = [
            WordCheckingReactorAssembly(),
            WordDetailReactorAssembly(),
            WordListReactorAssembly(),
        ]

        assemblies.forEach { assembly in
            assembly.assemble(container: container)
        }
    }

}

final class WordCheckingReactorAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WordCheckingReactor.self) { resolver in
            let wordUseCase: WordRxUseCaseProtocol = resolver.resolve()
            let userSettingsUseCase: UserSettingsUseCaseProtocol = resolver.resolve()

            return WordCheckingReactor.init(
                wordUseCase: wordUseCase,
                userSettingsUseCase: userSettingsUseCase,
                globalAction: .shared
            )
        }
    }

}

final class WordDetailReactorAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WordDetailReactor.self) { resolver, uuid in
            let wordUseCase: WordRxUseCaseProtocol = resolver.resolve()

            return WordDetailReactor.init(
                uuid: uuid,
                globalAction: .shared,
                wordUseCase: wordUseCase
            )
        }
    }

}

final class WordListReactorAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WordListReactor.self) { resolver in
            let wordUseCase: WordRxUseCaseProtocol = resolver.resolve()

            return .init(globalAction: .shared, wordUseCase: wordUseCase)
        }
    }

}
