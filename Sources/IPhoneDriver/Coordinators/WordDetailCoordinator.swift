//
//  WordDetailCoordinator.swift
//  iPhoneDriver
//
//  Created by Jaewon Yun on 2023/11/20.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Container
import IOSScene_WordDetail
import IOSSupport
import UIKit

public final class WordDetailCoordinator: BasicCoordinator {

    let uuid: UUID
    
    /// <#Description#>
    /// - Parameters:
    ///   - navigationController: Coordinator 가 시작될 `NavigationController`.
    ///   - uuid: 특정 단어의 UUID 입니다.
    public init(navigationController: UINavigationController, uuid: UUID) {
        self.uuid = uuid
        super.init(navigationController: navigationController)
    }
    
    public override func start() {
        let viewController: WordDetailViewControllerProtocol = container.resolve(argument: uuid)
        viewController.delegate = self
        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension WordDetailCoordinator: WordDetailViewControllerDelegate {
}
