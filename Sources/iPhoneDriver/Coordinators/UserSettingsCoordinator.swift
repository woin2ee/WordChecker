//
//  UserSettingsCoordinator.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import IOSSupport
import LanguageSetting
import SwinjectDIContainer
import SwinjectExtension
import UIKit
import UserSettings

final class UserSettingsCoordinator: BasicCoordinator {

    var observation: NSKeyValueObservation?

    override func start() {
        let viewController: UserSettingsViewControllerProtocol = DIContainer.shared.resolver.resolve()
        viewController.delegate = self
        navigationController.setViewControllers([viewController], animated: false)

        observation = RootTabBarController.shared.observe(to: .doubleTap, tabBarItemAt: 2) { [weak self] in
            self?.childCoordinators = []
        }
    }

}

extension UserSettingsCoordinator: UserSettingsViewControllerDelegate {

    func didTapSourceLanguageSettingRow() {
        let coordinator: LanguageSettingCoordinator = .init(navigationController: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start(with: TranslationDirection.sourceLanguage)
    }

    func didTapTargetLanguageSettingRow() {
        let coordinator: LanguageSettingCoordinator = .init(navigationController: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start(with: TranslationDirection.targetLanguage)
    }

    func didTapNotificationsSettingRow() {
        let coordinator: PushNotificationSettingsCoordinator = .init(navigationController: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func didTapGeneralSettingsRow() {
        let coordinator: GeneralSettingsCoordinator = .init(navigationController: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

}
