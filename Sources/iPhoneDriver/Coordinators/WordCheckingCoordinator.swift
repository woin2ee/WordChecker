//
//  WordCheckingCoordinator.swift
//  iPhoneDriver
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import DIContainer
import UIKit
import iOSCore

final class WordCheckingCoordinator: Coordinator {

    weak var parentCoordinator: iOSCore.Coordinator?
    var childCoordinators: [iOSCore.Coordinator] = []

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController: WordCheckingViewController = DIContainer.shared.resolver.resolve()
        navigationController.setViewControllers([viewController], animated: false)
    }

}
