//
//  AppDelegate.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import IOSDriver
import IPadDriver
import IPhoneDriver
import UIKit

@main
final class AppDelegate: CommonAppDelegate {

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        switch UIDevice.current.allowedIdiom {
        case .iPhone:
            UNUserNotificationCenter.current().delegate = IPhoneDriver.AppCoordinator.shared
        case .iPad:
            UNUserNotificationCenter.current().delegate = IPadDriver.AppCoordinator.shared
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
