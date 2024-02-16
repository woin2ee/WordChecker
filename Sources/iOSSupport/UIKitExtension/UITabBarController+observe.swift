//
//  UITabBarController+observe.swift
//  IOSSupport
//
//  Created by Jaewon Yun on 2/17/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import UIKit

extension UITabBarController {

    ///
    public func observe(
        to action: TabBarControllerUserAction,
        tabBarItemAt index: Int,
        handler: @escaping (() -> Void)
    ) -> NSKeyValueObservation {
        switch action {
        case .doubleTap:
            return self.observe(\.selectedViewController, options: [.old, .new]) { [weak self] _, selectedViewController in
                guard
                    let viewControllers = self?.viewControllers,
                    let oldSelectedViewController = selectedViewController.oldValue,
                    let newSelectedViewController = selectedViewController.newValue else {
                    return
                }

                if oldSelectedViewController === newSelectedViewController,
                   newSelectedViewController === viewControllers[index] {
                    handler()
                }
            }
        }
    }
}

/// `TabBarController` 에 대한 사용자의 행동을 표현하는 열거형입니다.
public enum TabBarControllerUserAction {

    /// 현재 선택된 탭 바 아이템을 다시 탭하는 행동
    case doubleTap
}
