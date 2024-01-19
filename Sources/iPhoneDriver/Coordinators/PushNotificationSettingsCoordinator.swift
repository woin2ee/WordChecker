//
//  PushNotificationSettingsCoordinator.swift
//  iPhoneDriver
//
//  Created by Jaewon Yun on 2023/12/08.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import iOSSupport
import PushNotificationSettings
import SwinjectDIContainer
import SwinjectExtension
import UIKit

final class PushNotificationSettingsCoordinator: Coordinator {

    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController: PushNotificationSettingsViewController = DIContainer.shared.resolver.resolve()
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }

}

extension PushNotificationSettingsCoordinator: PushNotificationSettingsDelegate {

    func willPopView() {
        navigationController.popViewController(animated: true)
        parentCoordinator?.childCoordinators.removeAll(where: { $0 === self })
    }

}
