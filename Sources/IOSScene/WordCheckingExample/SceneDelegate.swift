//
//  SceneDelegate.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

@testable import IOSScene_WordChecking

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: WordCheckingCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = .init(windowScene: windowScene)
        window?.makeKeyAndVisible()

        let navigationController: UINavigationController = .init()
        navigationController.tabBarItem = .init(tabBarSystemItem: .favorites, tag: 0)
        
        let tabBarController: UITabBarController = .init()
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance

        tabBarController.viewControllers = [navigationController]

        window?.rootViewController = tabBarController
        
        coordinator = WordCheckingCoordinator(navigationController: navigationController)
        coordinator?.start()
    }

}
