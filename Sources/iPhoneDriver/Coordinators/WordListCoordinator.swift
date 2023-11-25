//
//  WordListCoordinator.swift
//  iPhoneDriver
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import iOSSupport
import SwinjectDIContainer
import SwinjectExtension
import UIKit
import WordList

final class WordListCoordinator: Coordinator {

    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController: WordListViewController = DIContainer.shared.resolver.resolve()
        viewController.delegate = self
        navigationController.setViewControllers([viewController], animated: false)
    }

}

extension WordListCoordinator: WordListViewControllerDelegate, WordSearchResultsControllerDelegate {

    func didTapWordRow(with uuid: UUID) {
        let presentedNavigationController: UINavigationController = .init()

        let coordinator: WordDetailCoordinator = .init(navigationController: presentedNavigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start(with: uuid)

        navigationController.present(presentedNavigationController, animated: true)
    }

    func didTapAddWordButton() {
        let presentedNavigationController: UINavigationController = .init()

        let coordinator: WordAdditionCoordinator = .init(navigationController: presentedNavigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()

        navigationController.present(presentedNavigationController, animated: true)
    }

}
