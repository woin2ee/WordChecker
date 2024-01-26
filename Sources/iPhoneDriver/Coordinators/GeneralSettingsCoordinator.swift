//
//  GeneralSettingsCoordinator.swift
//  GeneralSettings
//
//  Created by Jaewon Yun on 1/25/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import GeneralSettings
import iOSSupport
import UIKit
import SwinjectDIContainer

final class GeneralSettingsCoordinator: Coordinator {

    weak var parentCoordinator: iOSSupport.Coordinator?
    var childCoordinators: [iOSSupport.Coordinator] = []

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController: GeneralSettingsViewControllerProtocol = DIContainer.shared.resolver.resolve()
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }

}

extension GeneralSettingsCoordinator: GeneralSettingsViewControllerDelegate {

    func willPopView() {
        navigationController.popViewController(animated: true)
        parentCoordinator?.childCoordinators.removeAll(where: { $0 === self })
    }

}
