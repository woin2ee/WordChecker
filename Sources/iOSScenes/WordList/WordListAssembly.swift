//
//  WordListAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Swinject
import SwinjectExtension
import Then

public final class WordListAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(WordListReactor.self) { resolver in
            let wordUseCase: WordUseCaseProtocol = resolver.resolve()

            return .init(globalAction: .shared, wordUseCase: wordUseCase)
        }

        container.register(WordListViewControllerProtocol.self) { resolver in
            let reactor: WordListReactor = resolver.resolve()

            return WordListViewController.init().then {
                $0.reactor = reactor
            }
        }
    }

}
