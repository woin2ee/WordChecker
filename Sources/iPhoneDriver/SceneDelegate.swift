//
//  SceneDelegate.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import iOSSupport
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var appCoordinator: AppCoordinator?

    let globalAction: GlobalReactorAction = .shared

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = .init(windowScene: windowScene)
        window?.makeKeyAndVisible()

        let rootTabBarController: UITabBarController = .init()
        window?.rootViewController = rootTabBarController

        appCoordinator = .init(rootTabBarController: rootTabBarController)
        appCoordinator?.start()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        globalAction.sceneWillEnterForeground.accept(())
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        globalAction.sceneDidBecomeActive.accept(())
    }

}
