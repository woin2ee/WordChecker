//
//  WordCheckingViewControllerAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/10/01.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Swinject

final class WordCheckingViewControllerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WordCheckingViewController.self) { resolver, delegate in
            let wordUseCase: WordUseCaseProtocol = resolver.resolve()
            let userSettingsUseCase: UserSettingsUseCaseProtocol = resolver.resolve()
            let state: UnmemorizedWordListStateProtocol = resolver.resolve()
            let viewModel: WordCheckingViewModelProtocol = WordCheckingViewModel.init(wordUseCase: wordUseCase, userSettingsUseCase: userSettingsUseCase, state: state, delegate: delegate)
            let viewController: WordCheckingViewController = .init(viewModel: viewModel)
            return viewController
        }
    }

}
