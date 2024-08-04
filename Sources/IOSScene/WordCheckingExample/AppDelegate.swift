//
//  AppDelegate.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import UIKit
import UtilitySource

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NetworkMonitor.start() // Not yet testable.
        return true
    }
}
