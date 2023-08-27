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
        container.register(WordCheckingViewController.self) { r in
            let wcRepository: WCRepository = r.resolve(WCRepository.self)!
            let viewModel: WordCheckingViewModel = .init(wcRepository: wcRepository)
            let viewController: WordCheckingViewController = .init(viewModel: viewModel)
            return viewController
        }
        container.register(WordListViewController.self) { r in
            let wcRepository: WCRepository = r.resolve(WCRepository.self)!
            let viewModel: WordListViewModel = .init(wcRepository: wcRepository)
            let viewController: WordListViewController = .init(viewModel: viewModel)
            return viewController
        }
    }
    
}
