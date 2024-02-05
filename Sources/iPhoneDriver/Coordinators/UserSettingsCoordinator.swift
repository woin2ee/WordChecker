//
//  UserSettingsCoordinator.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import iOSSupport
import LanguageSetting
import SwinjectDIContainer
import SwinjectExtension
import UIKit
import UserSettings

final class UserSettingsCoordinator: Coordinator {

    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController: UserSettingsViewControllerProtocol = DIContainer.shared.resolver.resolve()
        viewController.delegate = self
        navigationController.setViewControllers([viewController], animated: false)
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
