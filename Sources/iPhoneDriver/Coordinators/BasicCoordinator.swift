//
//  BasicCoordinator.swift
//  iPhoneDriver
//
//  Created by Jaewon Yun on 2/7/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import iOSSupport
import UIKit
import Utility

/// iOS 환경에서 동작하는 Coordinator 를 위한 Parent coordinator 클래스
///
/// - warning: Do not use instance of this class directly. Some methods in this class cause of fatal error.
class BasicCoordinator: Coordinator {

    weak var parentCoordinator: iOSSupport.Coordinator?
    var childCoordinators: [iOSSupport.Coordinator] = []

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        abstractMethod()
    }

    func start<Arg1>(with argument: Arg1) {
        abstractMethod()
    }

    func start<Arg1, Arg2>(with arguments: Arg1, _ arg2: Arg2) {
        abstractMethod()
    }

}

extension BasicCoordinator: ViewControllerDelegate {

    func viewControllerDidPop(_ viewController: UIViewController) {
        parentCoordinator?.childCoordinators.removeAll(where: { $0 === self })
    }

    func viewControllerMustBeDismissed(_ viewController: UIViewController) {
        navigationController.dismiss(animated: true) // In this case, `navigationController` property is represented the presented view controller.
        parentCoordinator?.childCoordinators.removeAll(where: { $0 === self })
    }

    func viewControllerDidDismiss(_ viewController: UIViewController) {
        parentCoordinator?.childCoordinators.removeAll(where: { $0 === self })
    }

}
