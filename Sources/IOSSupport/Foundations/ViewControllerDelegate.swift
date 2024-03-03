//
//  ViewControllerDelegate.swift
//  iPhoneDriver
//
//  Created by Jaewon Yun on 2/7/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import UIKit

/// `UIViewController` 를 위한 기본적인 Delegate methods 가 정의되어 있는 Protocol 입니다.
public protocol ViewControllerDelegate: AnyObject {

    /// ViewController 가 Pop 되었음을 Delegate 에게 알립니다.
    func viewControllerDidPop(_ viewController: UIViewController)

    /// ViewController 가 Dismiss 되어야 함을 Delegate 에게 알립니다.
    ///
    /// 이 Delegate method 를 구현하는 Subclass 는 직접 ViewController 에 대한 Dismiss 처리를 해야합니다.
    func viewControllerMustBeDismissed(_ viewController: UIViewController)

    /// ViewController 가 Dismiss 되었음을 Delegate 에게 알립니다.
    func viewControllerDidDismiss(_ viewController: UIViewController)

}
