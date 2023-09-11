//
//  UIViewControllerAssembly.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/27.
//

import Domain
import Foundation
import Swinject

final class UIViewControllerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WordCheckingViewController.self) { resolver in
            let wordUseCase: WordUseCaseProtocol = resolver.resolve()
            let state: UnmemorizedWordListStateProtocol = resolver.resolve()
            let viewModel: WordCheckingViewModelProtocol = WordCheckingViewModel.init(wordUseCase: wordUseCase, state: state)
            let viewController: WordCheckingViewController = .init(viewModel: viewModel)
            return viewController
        }
        container.register(WordListViewController.self) { resolver in
            let wordUseCase: WordUseCaseProtocol = resolver.resolve()
            let viewModel: WordListViewModelProtocol = WordListViewModel.init(wordUseCase: wordUseCase)
            let viewController: WordListViewController = .init(viewModel: viewModel)
            return viewController
        }
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
        container.register(WordAdditionViewController.self) { resolver, delegate in
            let wordUseCase: WordRxUseCaseProtocol = resolver.resolve()
            let viewModel: WordAdditionViewModel = .init(wordUseCase: wordUseCase, delegate: delegate)
            let viewController: WordAdditionViewController = .init(viewModel: viewModel)
            return viewController
        }
    }

}