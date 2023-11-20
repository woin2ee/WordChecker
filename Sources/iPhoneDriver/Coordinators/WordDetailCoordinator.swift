//
//  WordDetailCoordinator.swift
//  iPhoneDriver
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import DIContainer
import UIKit
import iOSCore

final class WordDetailCoordinator: Coordinator {

    weak var parentCoordinator: iOSCore.Coordinator?
    var childCoordinators: [iOSCore.Coordinator] = []

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start<Arg1>(with argument: Arg1) {
        let viewController: WordDetailViewController = DIContainer.shared.resolver.resolve(argument: argument)
        viewController.delegate = self
        navigationController.setViewControllers([viewController], animated: false)
    }

}

extension WordDetailCoordinator: WordDetailViewControllerDelegate {

    func didFinishInteraction() {
        navigationController.dismiss(animated: true)
        parentCoordinator?.childCoordinators.removeAll(where: { $0 === self })
    }

}
