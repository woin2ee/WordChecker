//
//  LanguageSettingCoordinator.swift
//  iPhoneDriver
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import IOSSupport
import SwinjectDIContainer
import SwinjectExtension
import UIKit

internal final class LanguageSettingCoordinator: BasicCoordinator {

    override func start<Arg1>(with argument: Arg1) {
        let viewController: LanguageSettingViewControllerProtocol = DIContainer.shared.resolver.resolve(argument: argument)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }

}

extension LanguageSettingCoordinator: LanguageSettingViewControllerDelegate {
}
