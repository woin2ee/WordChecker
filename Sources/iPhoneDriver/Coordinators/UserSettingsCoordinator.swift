//
//  UserSettingsCoordinator.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import UIKit
import iOSCore
import SwinjectExtension

final class UserSettingsCoordinator: Coordinator {

    weak var parentCoordinator: iOSCore.Coordinator?
    var childCoordinators: [iOSCore.Coordinator] = []

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController: UserSettingsViewController = DIContainer.shared.resolver.resolve()
        viewController.delegate = self
        navigationController.setViewControllers([viewController], animated: false)
    }

}

extension UserSettingsCoordinator: UserSettingsViewControllerDelegate {

    func didTapLanguageSettingRow(settingsDirection: LanguageSettingViewModel.SettingsDirection, currentSettingLocale: TranslationLanguage) {
        let coordinator: LanguageSettingCoordinator = .init(navigationController: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start(with: settingsDirection, currentSettingLocale)
    }

}
