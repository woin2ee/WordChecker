//
//  SceneDelegate.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import IOSSupport
import RxSwift
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    let disposeBag: DisposeBag = .init()

    var window: UIWindow?

    var appCoordinator: AppCoordinator?

    let globalAction: GlobalAction = .shared
    let globalState: GlobalState = .shared

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = .init(windowScene: windowScene)
        window?.makeKeyAndVisible()

        setRootViewController()

        subscribeGlobalAction()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        globalAction.sceneWillEnterForeground.accept(())
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        globalAction.sceneDidBecomeActive.accept(())
    }

    func setRootViewController() {
        let rootTabBarController: RootTabBarController = .shared
        window?.rootViewController = rootTabBarController

        appCoordinator = .init(rootTabBarController: rootTabBarController)
        appCoordinator?.start()
    }

    func subscribeGlobalAction() {
        globalState.themeStyle
            .asDriver()
            .drive(with: self) { owner, userInterfaceStyle in
                owner.window?.overrideUserInterfaceStyle = userInterfaceStyle
            }
            .disposed(by: disposeBag)
    }

}
