//
//  WordCheckingCoordinator.swift
//  iPhoneDriver
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import iOSSupport
import SwinjectDIContainer
import SwinjectExtension
import UIKit
import WordChecking

final class WordCheckingCoordinator: BasicCoordinator {

    override func start() {
        let viewController: WordCheckingViewControllerProtocol = DIContainer.shared.resolver.resolve()
        navigationController.setViewControllers([viewController], animated: false)
    }

}
