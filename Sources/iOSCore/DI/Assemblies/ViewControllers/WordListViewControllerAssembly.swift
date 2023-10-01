//
//  WordListViewControllerAssembly.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/10/01.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Swinject

final class WordListViewControllerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WordListViewController.self) { resolver in
            let wordUseCase: WordUseCaseProtocol = resolver.resolve()
            let viewModel: WordListViewModelProtocol = WordListViewModel.init(wordUseCase: wordUseCase)
            let viewController: WordListViewController = .init(viewModel: viewModel)
            return viewController
        }
    }

}
