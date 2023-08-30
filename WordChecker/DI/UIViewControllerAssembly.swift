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
            let wcRepository: WCRepository = resolver.resolve(WCRepository.self)!
            let viewModel: WordCheckingViewModel = .init(wcRepository: wcRepository)
            let viewController: WordCheckingViewController = .init(viewModel: viewModel)
            return viewController
        }
        container.register(WordListViewController.self) { resolver in
            let wcRepository: WCRepository = resolver.resolve(WCRepository.self)!
            let viewModel: WordListViewModel = .init(wcRepository: wcRepository)
            let viewController: WordListViewController = .init(viewModel: viewModel)
            return viewController
        }
    }

}
