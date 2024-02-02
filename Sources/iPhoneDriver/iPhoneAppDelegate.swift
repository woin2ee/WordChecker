//
//  iPhoneAppDelegate.swift
//  iPhoneDriver
//
//  Created by Jaewon Yun on 1/30/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import DataDriver
import Domain
import GeneralSettings
import GoogleSignIn
import Infrastructure
import iOSSupport
import LanguageSetting
import PushNotificationSettings
import RxSwift
import Swinject
import SwinjectDIContainer
import UIKit
import UserSettings
import Utility
import WordAddition
import WordChecking
import WordDetail
import WordList

// swiftlint:disable type_name
open class iPhoneAppDelegate: UIResponder, UIApplicationDelegate {

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initDIContainer()
        initGlobalState()
        restoreGoogleSignInState()
        NetworkMonitor.start()
        UNUserNotificationCenter.current().delegate = self

        return true
    }

    public func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        var handled: Bool

        handled = GIDSignIn.sharedInstance.handle(url)

        if handled {
            return true
        }

        // Handle other custom URL types.

        // If not handled by this app, return false.
        return false
    }

    // MARK: UISceneSession Lifecycle

    public func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return .init(name: "DefaultConfiguration", sessionRole: connectingSceneSession.role)
    }

    public func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: Helpers

    open func restoreGoogleSignInState() {
        let googleDriveUseCase: ExternalStoreUseCaseProtocol = DIContainer.shared.resolver.resolve()
        googleDriveUseCase.restoreSignIn()
            .subscribe(on: ConcurrentMainScheduler.instance)
            .subscribe()
            .dispose()
    }

    open func initDIContainer() {
        DIContainer.shared.assembler.apply(assemblies: [
            DomainAssembly(),
            DataDriverAssembly(),
            WordCheckingAssembly(),
            WordListAssembly(),
            WordDetailAssembly(),
            WordAdditionAssembly(),
            UserSettingsAssembly(),
            LanguageSettingAssembly(),
            PushNotificationSettingsAssembly(),
            GeneralSettingsAssembly(),
            InfrastructureAssembly(),
        ])
    }

    func initGlobalState() {
        let userSettingsUseCase: UserSettingsUseCaseProtocol = DIContainer.shared.resolver.resolve()
        _ = userSettingsUseCase.getCurrentUserSettings()
            .map(\.hapticsIsOn)
            .doOnSuccess(GlobalState.shared.initialize)
            .subscribe(on: ConcurrentMainScheduler.instance)
            .subscribe()
    }

}

extension iPhoneAppDelegate: UNUserNotificationCenterDelegate {

    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        RootTabBarController.shared.selectedViewController = RootTabBarController.shared.wordCheckingNC
    }

}
