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

        observation = observePopToRoot()
    }

    func observePopToRoot() -> NSKeyValueObservation {
        return RootTabBarController.shared.observe(\.selectedViewController, options: [.old, .new]) { [weak self] _, selectedVC in
            guard let oldNC = selectedVC.oldValue as? UserSettingsNavigationController,
                  let newNC = selectedVC.newValue as? UserSettingsNavigationController else {
                return
            }
            if oldNC === newNC { // equals pop to root view controller.
                self?.childCoordinators = []
            }
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
