//
//  SceneDelegate.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import IOSScene_UserSettings
import IOSSupport
import RxSwift
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let disposeBag = DisposeBag()
    var coordinator: UserSettingsCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = .init(windowScene: windowScene)
        window?.makeKeyAndVisible()

        let navigationController: UINavigationController = .init()
        navigationController.tabBarItem = .init(title: "Settings", image: .init(systemName: "gearshape"), tag: 0)

        let tabBarController: UITabBarController = .init()

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance

        tabBarController.viewControllers = [navigationController]
        
        window?.rootViewController = tabBarController
        
        coordinator = UserSettingsCoordinator(navigationController: navigationController)
        coordinator?.start()
        
        GlobalState.shared.themeStyle
            .asDriver()
            .drive(with: self) { owner, userInterfaceStyle in
                owner.window?.overrideUserInterfaceStyle = userInterfaceStyle
            }
            .disposed(by: disposeBag)
    }

}
