//
//  WordCheckingAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import IOSSupport
import Swinject
import SwinjectExtension
import Then
import UseCase_UserSettings
import UseCase_Word

public final class WordCheckingAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(WordCheckingReactor.self) { resolver in
            let wordUseCase: WordUseCaseProtocol = resolver.resolve()
            let userSettingsUseCase: UserSettingsUseCaseProtocol = resolver.resolve()

            return WordCheckingReactor(
                wordUseCase: wordUseCase,
                userSettingsUseCase: userSettingsUseCase,
                globalAction: GlobalAction.shared
            )
        }

        container.register(WordCheckingViewControllerProtocol.self) { resolver in
            let reactor: WordCheckingReactor = resolver.resolve()

            return WordCheckingViewController().then {
                $0.reactor = reactor
            }
        }
    }

}
