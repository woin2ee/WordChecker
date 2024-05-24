//
//  LanguageSettingCoordinator.swift
//  iPhoneDriver
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Container
import IOSScene_UserSettings
import IOSSupport
import UIKit

internal final class LanguageSettingCoordinator: BasicCoordinator {

    let translationDirection: TranslationDirection
    
    init(navigationController: UINavigationController, translationDirection: TranslationDirection) {
        self.translationDirection = translationDirection
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let viewController: LanguageSettingViewControllerProtocol = container.resolve(argument: translationDirection)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }

}

extension LanguageSettingCoordinator: LanguageSettingViewControllerDelegate {
}
