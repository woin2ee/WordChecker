//
//  GeneralSettingsCoordinator.swift
//  GeneralSettings
//
//  Created by Jaewon Yun on 1/25/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Container
import IOSScene_UserSettings
import IOSSupport
import UIKit

internal final class GeneralSettingsCoordinator: BasicCoordinator {

    override func start() {
        let viewController: GeneralSettingsViewControllerProtocol = container.resolve()
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }

}

extension GeneralSettingsCoordinator: GeneralSettingsViewControllerDelegate {

    func didTapThemeSetting() {
        let coordinator: ThemeSettingCoordinator = .init(navigationController: navigationController)
        coordinator.parentCoordinator = self
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }

}
