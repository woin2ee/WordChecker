//
//  WordCheckingCoordinator.swift
//  iPhoneDriver
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import IOSSupport
import SwinjectDIContainer
import SwinjectExtension
import UIKit

public final class WordCheckingCoordinator: BasicCoordinator {

    public override func start() {
        let viewController: WordCheckingViewControllerProtocol = DIContainer.shared.resolver.resolve()
        navigationController.setViewControllers([viewController], animated: false)
    }

}
