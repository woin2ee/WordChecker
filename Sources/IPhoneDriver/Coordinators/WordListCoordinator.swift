//
//  WordListCoordinator.swift
//  iPhoneDriver
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import IOSScene_WordDetail
import IOSScene_WordList
import IOSSupport
import SwinjectDIContainer
import SwinjectExtension
import UIKit

/// WordList(ViewController) 를 포함하여 연관된 View 들의 화면 전환 책임을 수행하는 객체입니다.
final class WordListCoordinator: BasicCoordinator {

    var observation: NSKeyValueObservation?

    override func start() {
        let viewController: WordListViewControllerProtocol = DIContainer.shared.resolver.resolve()
        viewController.delegate = self
        navigationController.setViewControllers([viewController], animated: false)

        observation = RootTabBarController.shared.observe(to: .doubleTap, tabBarItemAt: 1) { [weak viewController] in
            viewController?.scrollToTop()
        }
    }

}

extension WordListCoordinator: WordListViewControllerDelegate, WordSearchResultsControllerDelegate {

    func didTapWordRow(with uuid: UUID) {
        let presentedNavigationController: UINavigationController = .init()

        let coordinator: WordDetailCoordinator = .init(
            navigationController: presentedNavigationController,
            uuid: uuid
        )
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()

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
