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
            let viewController: WordCheckingViewController = .init(store: store)
            return viewController
        }
        container.register(WordListViewController.self) { resolver in
            let store: StateStore = resolver.resolve()
            let viewController: WordListViewController = .init(store: store)
            return viewController
        }
        container.register(WordDetailViewController.self) { resolver in
            let store: StateStore = resolver.resolve()
            let viewController: WordDetailViewController = .init(store: store)
            return viewController
        }
    }

}
