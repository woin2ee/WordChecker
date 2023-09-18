//
//  AppDelegate.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import Domain
import iOSCore
import RxSwift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let disposeBag: DisposeBag = .init()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DIContainer.shared.assembler.apply(assembly: RealmPlatformAssembly())

        initUserSettingsIfFirstLaunch()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig: UISceneConfiguration = .init(name: "DefaultConfig", sessionRole: .windowApplication)
        sceneConfig.delegateClass = iOSCore.SceneDelegate.self
        return sceneConfig
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension AppDelegate {

    func initUserSettingsIfFirstLaunch() {
        let userSettingsUseCase: UserSettingsUseCaseProtocol = DIContainer.shared.resolve()

        userSettingsUseCase.currentUserSettings
            .mapToVoid()
            .catch { _ in
                userSettingsUseCase.initUserSettings()
                    .mapToVoid()
            }
            .subscribe()
            .disposed(by: disposeBag)
    }

}
