//
//  WordCheckingCoordinator.swift
//  iPhoneDriver
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Container
import IOSScene_WordChecking
import IOSSupport
import SwinjectExtension
import UIKit

public final class WordCheckingCoordinator: BasicCoordinator {

    public override func start() {
        let viewController: WordCheckingViewControllerProtocol = container.resolve()
        navigationController.setViewControllers([viewController], animated: false)
    }

}
