//
//  WordCheckingReactorAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import iOSCore
import Swinject
import SwinjectExtension

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
