//
//  WordDetailViewControllerAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/10/01.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Swinject

final class WordDetailViewControllerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WordDetailViewController.self) { resolver, uuid, delegate in
            let wordUseCase: WordUseCaseProtocol = resolver.resolve()
            let viewModel: WordDetailViewModelProtocol = WordDetailViewModel.init(
                wordUseCase: wordUseCase,
                uuid: uuid,
                delegate: delegate
            )
            let viewController: WordDetailViewController = .init(viewModel: viewModel)
            return viewController
        }
    }

}
