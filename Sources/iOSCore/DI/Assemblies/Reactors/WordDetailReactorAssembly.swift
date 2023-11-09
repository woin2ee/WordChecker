//
//  WordDetailReactorAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/09.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import Swinject

final class WordDetailReactorAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(WordDetailReactor.self) { resolver, uuid, delegate in
            let wordUseCase: WordRxUseCaseProtocol = resolver.resolve()

            return WordDetailReactor.init(
                uuid: uuid,
                globalAction: .shared,
                wordUseCase: wordUseCase,
                delegate: delegate
            )
        }
    }
    
}
