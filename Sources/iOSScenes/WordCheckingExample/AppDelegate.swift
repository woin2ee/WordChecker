//
//  AppDelegate.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import iOSSupport
import UIKit
import Utility

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NetworkMonitor.start()
        GlobalState.shared.initialize(hapticsIsOn: true, themeStyle: .unspecified)
        return true
    }

}
