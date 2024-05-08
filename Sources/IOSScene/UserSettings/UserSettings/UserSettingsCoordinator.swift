//
//  UserSettingsCoordinator.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import IOSSupport
import SwinjectDIContainer
import SwinjectExtension
import UIKit

public final class UserSettingsCoordinator: BasicCoordinator {

    public override func start() {
        let viewController: UserSettingsViewControllerProtocol = DIContainer.shared.resolver.resolve()
        viewController.delegate = self
        navigationController.setViewControllers([viewController], animated: false)
    }

}

extension UserSettingsCoordinator: UserSettingsViewControllerDelegate {

    public func didTapSourceLanguageSettingRow() {
        let coordinator: LanguageSettingCoordinator = .init(
            navigationController: navigationController,
            translationDirection: .sourceLanguage
        )
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    public func didTapTargetLanguageSettingRow() {
        let coordinator: LanguageSettingCoordinator = .init(
            navigationController: navigationController,
            translationDirection: .targetLanguage
        )
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    public func didTapNotificationsSettingRow() {
        let coordinator: PushNotificationSettingsCoordinator = .init(navigationController: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    public func didTapGeneralSettingsRow() {
        let coordinator: GeneralSettingsCoordinator = .init(navigationController: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

}
