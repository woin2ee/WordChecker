//
//  UIViewControllerAssembly.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/27.
//

import Foundation
import Swinject

final class UIViewControllerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WordCheckingViewController.self) { resolver in
            let store: AppStore = resolver.resolve()
            let viewModel: WordCheckingViewModel = .init(store: store)
            let viewController: WordCheckingViewController = .init(viewModel: viewModel)
            return viewController
        }
        container.register(WordListViewController.self) { resolver in
            let store: AppStore = resolver.resolve()
            let viewModel: WordListViewModel = .init(store: store)
            let viewController: WordListViewController = .init(viewModel: viewModel)
            return viewController
        }
    }

}
