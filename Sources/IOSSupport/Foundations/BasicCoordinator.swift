//
//  BasicCoordinator.swift
//  iPhoneDriver
//
//  Created by Jaewon Yun on 2/7/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import UIKit
import Utility

/// iOS 환경에서 동작하는 Coordinator 를 위한 Abstract 클래스
///
/// - warning: Do not use instance of this class directly. Some methods in this class cause of fatal error.
open class BasicCoordinator: Coordinator {

    public weak var parentCoordinator: Coordinator?
    public var childCoordinators: [Coordinator] = []

    public weak var navigationController: UINavigationController?

    public init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    /// Start this coordinator.
    ///
    /// Coordinator 가 담당하는 View 가 화면에 Display 되며 실제로 메모리에 적재됨을 의미합니다.
    open func start() {
        abstractMethod()
    }

    open func start<Arg1>(with argument: Arg1) {
        abstractMethod()
    }

    open func start<Arg1, Arg2>(with arguments: Arg1, _ arg2: Arg2) {
        abstractMethod()
    }

}

extension BasicCoordinator: ViewControllerDelegate {

    public func viewControllerDidPop(_ viewController: UIViewController) {
        parentCoordinator?.childCoordinators.removeAll(where: { $0 === self })
    }

    public func viewControllerMustBeDismissed(_ viewController: UIViewController) {
        // In this case, `navigationController` property is represented the presented view controller.
        navigationController?.dismiss(animated: true)
        parentCoordinator?.childCoordinators.removeAll(where: { $0 === self })
    }

    public func viewControllerDidDismiss(_ viewController: UIViewController) {
        parentCoordinator?.childCoordinators.removeAll(where: { $0 === self })
    }

}
