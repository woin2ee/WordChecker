//
//  UIViewControllerAssembly.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/27.
//

import Foundation
import StateStore
import Swinject

final class UIViewControllerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WordCheckingViewController.self) { resolver in
            let store: StateStore = resolver.resolve()
            let viewModel: WordCheckingViewModelProtocol = WordCheckingViewModel.init(store: store)
            let viewController: WordCheckingViewController = .init(viewModel: viewModel)
            return viewController
        }
        container.register(WordListViewController.self) { resolver in
            let store: StateStore = resolver.resolve()
            let viewModel: WordListViewModelProtocol = WordListViewModel.init(store: store)
            let viewController: WordListViewController = .init(viewModel: viewModel)
            return viewController
        }
        container.register(WordDetailViewController.self) { resolver in
            let store: StateStore = resolver.resolve()
            let viewModel: WordDetailViewModelProtocol = WordDetailViewModel.init(store: store)
            let viewController: WordDetailViewController = .init(viewModel: viewModel)
            return viewController
        }
    }

}
