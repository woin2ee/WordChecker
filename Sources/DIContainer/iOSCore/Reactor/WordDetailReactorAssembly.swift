//
//  WordDetailReactorAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import iOSCore
import Swinject
import SwinjectExtension

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
