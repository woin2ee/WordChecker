//
//  Created by Jaewon Yun on 1/30/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Container
import GoogleSignIn
import IOSSupport
import RxSwift
import Swinject
import UIKit
import Utility

// Domain
import Domain_GoogleDrive
import Domain_LocalNotification
import Domain_UserSettings
import Domain_Word

// UseCase
import UseCase_GoogleDrive
import UseCase_LocalNotification
import UseCase_UserSettings
import UseCase_Word

// Scenes
import IOSScene_UserSettings
import IOSScene_WordAddition
import IOSScene_WordChecking
import IOSScene_WordDetail
import IOSScene_WordList

open class CommonAppDelegate: UIResponder, UIApplicationDelegate {

    open func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        initializeContainer()
        initializeGlobalState()
        restoreGoogleSignInState()
        NetworkMonitor.start()

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
        switch UIDevice.current.allowedIdiom {
        case .iPhone:
            return .init(name: "IPhoneSceneConfiguration", sessionRole: connectingSceneSession.role)
        case .iPad:
            return .init(name: "IPadSceneConfiguration", sessionRole: connectingSceneSession.role)
        }
    }

    public func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    open func restoreGoogleSignInState() {
        let googleDriveUseCase: GoogleDriveUseCase = container.resolve()
        googleDriveUseCase.restoreSignIn()
            .subscribe(on: ConcurrentMainScheduler.instance)
            .subscribe()
            .dispose()
    }

    open func initializeContainer() {
        container.apply(assemblies: [
            // Domain
            DomainGoogleDriveAssembly(),
            DomainLocalNotificationAssembly(),
            DomainUserSettingsAssembly(),
            DomainWordAssembly(),

            // UseCase
            GoogleDriveUseCaseAssembly(),
            LocalNotificationsUseCaseAssembly(),
            UserSettingsUseCaseAssembly(),
            WordUseCaseAssembly(),

            // IOSScene
            WordCheckingAssembly(),
            WordListAssembly(),
            WordDetailAssembly(),
            WordAdditionAssembly(),
            IOSSceneUserSettingsAssembly(),
        ])
    }
}

// MARK: Helpers

extension CommonAppDelegate {
    
    private func initializeGlobalState() {
        let userSettingsUseCase: UserSettingsUseCase = container.resolve()
        _ = userSettingsUseCase.getCurrentUserSettings()
            .doOnSuccess {
                GlobalState.shared.initialize(
                    hapticsIsOn: $0.hapticsIsOn,
                    themeStyle: $0.themeStyle.toUIKit(),
                    autoCapitalizationIsOn: $0.autoCapitalizationIsOn
                )
            }
            .subscribe(on: ConcurrentMainScheduler.instance)
            .subscribe()
    }
}
