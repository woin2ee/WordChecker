//
//  WordDetailCoordinator.swift
//  iPhoneDriver
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import iOSSupport
import SwinjectDIContainer
import SwinjectExtension
import UIKit
import WordDetail

final class WordDetailCoordinator: BasicCoordinator {

    override func start<Arg1>(with argument: Arg1) {
        let viewController: WordDetailViewControllerProtocol = DIContainer.shared.resolver.resolve(argument: argument)
        viewController.delegate = self
        navigationController.setViewControllers([viewController], animated: false)
    }

}

extension WordDetailCoordinator: WordDetailViewControllerDelegate {
}
