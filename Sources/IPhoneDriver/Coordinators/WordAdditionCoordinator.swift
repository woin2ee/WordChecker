//
//  WordAdditionCoordinator.swift
//  iPhoneDriver
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import IOSScene_WordAddition
import IOSSupport
import SwinjectDIContainer
import SwinjectExtension
import UIKit

final class WordAdditionCoordinator: BasicCoordinator {

    override func start() {
        let viewController: WordAdditionViewControllerProtocol = DIContainer.shared.resolver.resolve()
        viewController.delegate = self
        navigationController?.setViewControllers([viewController], animated: true)
    }

}

extension WordAdditionCoordinator: WordAdditionViewControllerDelegate {
}
