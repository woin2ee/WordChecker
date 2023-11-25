//
//  WordCheckingAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Swinject
import SwinjectExtension
import Then

public final class WordCheckingAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(WordCheckingReactor.self) { resolver in
            let wordUseCase: WordRxUseCaseProtocol = resolver.resolve()
            let userSettingsUseCase: UserSettingsUseCaseProtocol = resolver.resolve()

            return WordCheckingReactor.init(
                wordUseCase: wordUseCase,
                userSettingsUseCase: userSettingsUseCase,
                globalAction: .shared
            )
        }

        container.register(WordCheckingViewController.self) { resolver in
            let reactor: WordCheckingReactor = resolver.resolve()

            return .init().then {
                $0.reactor = reactor
            }
        }
    }

}
