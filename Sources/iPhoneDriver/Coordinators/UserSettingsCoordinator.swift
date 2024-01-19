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

    func didTapSourceLanguageSettingRow(currentSettingLocale: TranslationLanguage) {
        let coordinator: LanguageSettingCoordinator = .init(navigationController: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start(with: LanguageSettingViewModel.SettingsDirection.sourceLanguage, currentSettingLocale)
    }

    func didTapTargetLanguageSettingRow(currentSettingLocale: TranslationLanguage) {
        let coordinator: LanguageSettingCoordinator = .init(navigationController: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start(with: LanguageSettingViewModel.SettingsDirection.targetLanguage, currentSettingLocale)
    }

    func didTapNotificationsSettingRow() {
        let coordinator: PushNotificationSettingsCoordinator = .init(navigationController: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

}
