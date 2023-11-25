//
//  UNUserNotificationCenterDelegateMock.swift
//  WCNotificationCenterTests
//
//  Created by Jaewon Yun on 11/26/23.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import UIKit

final class DelegateMock: UIViewController, UNUserNotificationCenterDelegate {

    var didCall: Int = 0

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        didCall += 1
    }

}
