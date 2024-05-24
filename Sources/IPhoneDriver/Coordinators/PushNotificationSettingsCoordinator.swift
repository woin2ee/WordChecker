//
//  PushNotificationSettingsCoordinator.swift
//  iPhoneDriver
//
//  Created by Jaewon Yun on 2023/12/08.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Container
import IOSScene_UserSettings
import IOSSupport
import UIKit

internal final class PushNotificationSettingsCoordinator: BasicCoordinator {

    override func start() {
        let viewController: PushNotificationSettingsViewControllerProtocol = container.resolve()
        viewController.delegate = self
        self.navigationController.pushViewController(viewController, animated: true)
    }

}

extension PushNotificationSettingsCoordinator: PushNotificationSettingsDelegate {
}
