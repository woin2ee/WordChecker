//
//  PushNotificationSettingsCoordinator.swift
//  iPhoneDriver
//
//  Created by Jaewon Yun on 2023/12/08.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import IOSScene_PushNotificationSettings
import SwinjectDIContainer
import SwinjectExtension
import UIKit

final class PushNotificationSettingsCoordinator: BasicCoordinator {

    override func start() {
        let viewController: PushNotificationSettingsViewControllerProtocol = DIContainer.shared.resolver.resolve()
        viewController.delegate = self
        self.navigationController.pushViewController(viewController, animated: true)
    }

}

extension PushNotificationSettingsCoordinator: PushNotificationSettingsDelegate {
}
