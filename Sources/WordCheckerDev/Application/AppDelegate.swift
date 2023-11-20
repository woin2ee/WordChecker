//
//  AppDelegate.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import DataDriver
import Domain
import GoogleSignIn
import iOSCore
import RxSwift
import Swinject
import SwinjectExtension
import UIKit
import Utility

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        injectDependencies()
        initUserSettingsIfFirstLaunch()
        NetworkMonitor.start()

        return true
    }

    func application(
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

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return .init(name: "DefaultConfiguration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension AppDelegate {

    func initUserSettingsIfFirstLaunch() {
        let userSettingsUseCase: UserSettingsUseCaseProtocol = DIContainer.shared.resolver.resolve()

        userSettingsUseCase.currentUserSettings
            .mapToVoid()
            .catch { _ in
                userSettingsUseCase.initUserSettings()
                    .mapToVoid()
            }
            .subscribe()
            .dispose()
    }

    func injectDependencies() {
        DIContainer.shared.assembler.apply(assemblies: [
            UseCaseAssembly(),
            ViewControllerAssembly(),
            RepositoryAssembly(
                userSettingsRepositoryAssembly: UserSettingsRepositoryDevAssembly(),
                wordRepositoryAssembly: WordRepositoryDevAssembly()
            ),
            ReactorsAssembly(),
        ])
    }

}
