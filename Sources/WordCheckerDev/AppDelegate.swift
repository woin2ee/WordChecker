//
//  AppDelegate.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import Container
import IOSDriver
import IPadDriver
import IPhoneDriver
import Swinject
import UIKit

// Domain
import Domain_UserSettings
import Domain_WordManagement

// Scenes
import IOSScene_UserSettings

@main
class AppDelegate: CommonAppDelegate {

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        switch UIDevice.current.allowedIdiom {
        case .iPhone:
            UNUserNotificationCenter.current().delegate = IPhoneDriver.AppCoordinator.shared
        case .iPad:
            UNUserNotificationCenter.current().delegate = IPadDriver.AppCoordinator.shared
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func restoreGoogleSignInState() {
        // No restore for dev.
    }
    
    override func initializeContainer() {
        super.initializeContainer()
        
        // Overwrite Assemblies
        container.apply(assemblies: [
            DomainUserSettingsAssemblyDev(),
            DomainWordAssemblyDev(),
            IOSSceneUserSettingsAssemblyDev(),
        ])
    }
}
