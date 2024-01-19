//
//  SceneDelegate.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

@testable import PushNotificationSettings

import DomainTesting
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = .init(windowScene: windowScene)
        window?.makeKeyAndVisible()

        let viewController: PushNotificationSettingsViewController = .init()
        let reactor: PushNotificationSettingsReactor = .init(userSettingsUseCase: UserSettingsUseCaseFake())
        viewController.reactor = reactor

        let navigationController: UINavigationController = .init(rootViewController: viewController)
        navigationController.tabBarItem = .init(title: "Settings", image: .init(systemName: "gearshape"), tag: 0)

        let tabBarController: UITabBarController = .init()

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance

        tabBarController.viewControllers = [navigationController]

        window?.rootViewController = tabBarController
    }

}
