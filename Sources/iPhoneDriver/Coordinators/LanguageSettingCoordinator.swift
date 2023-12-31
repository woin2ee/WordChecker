//
//  LanguageSettingCoordinator.swift
//  iPhoneDriver
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import iOSSupport
import LanguageSetting
import SwinjectDIContainer
import SwinjectExtension
import UIKit

final class LanguageSettingCoordinator: Coordinator {

    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start<Arg1, Arg2>(with arguments: Arg1, _ arg2: Arg2) {
        let viewController: LanguageSettingViewController = DIContainer.shared.resolver.resolve(arguments: arguments, arg2)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }

}

extension LanguageSettingCoordinator: LanguageSettingViewControllerDelegate {

    func didSelectLanguageRow() {
        navigationController.popViewController(animated: true)
        parentCoordinator?.childCoordinators.removeAll(where: { $0 === self })
    }

}
