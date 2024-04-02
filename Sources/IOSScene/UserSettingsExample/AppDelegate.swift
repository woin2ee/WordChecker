//
//  AppDelegate.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import IOSScene_UserSettings
import Swinject
import SwinjectDIContainer
import UIKit
import UseCase_LocalNotificationTesting
import UseCase_GoogleDriveTesting
import UseCase_UserSettingsTesting

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DIContainer.shared.assembler.apply(assemblies: [
            IOSSceneUserSettingsAssembly(),
            UserSettingsUseCaseFakeAssembly(),
            GoogleDriveUseCaseFakeAssembly(),
            LocalNotificationsUseCaseMockAssembly(),
        ])
        
        return true
    }

}
