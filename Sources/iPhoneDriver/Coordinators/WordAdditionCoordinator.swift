//
//  WordAdditionCoordinator.swift
//  iPhoneDriver
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import DIContainer
import UIKit
import iOSCore

final class WordAdditionCoordinator: Coordinator {

    weak var parentCoordinator: iOSCore.Coordinator?
    var childCoordinators: [iOSCore.Coordinator] = []

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController: WordAdditionViewController = DIContainer.shared.resolver.resolve()
        viewController.delegate = self
        navigationController.setViewControllers([viewController], animated: true)
    }

}

extension WordAdditionCoordinator: WordAdditionViewControllerDelegate {

    func didFinishInteration() {
        navigationController.dismiss(animated: true)
        parentCoordinator?.childCoordinators.removeAll(where: { $0 === self })
    }

}
