//
//  SceneDelegate.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

@testable import IOSScene_WordChecking
import IOSSupport
import Inject
import Then
import UIKit
import UseCase_UserSettingsTesting
import UseCase_WordTesting

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let reactor = WordCheckingReactor(
        wordUseCase: FakeWordUseCase().then { useCase in
            (1...10).forEach { number in
                _ = useCase.addNewWord("lorem ipsum \(number)")
                    .subscribe()
            }
        },
        userSettingsUseCase: UserSettingsUseCaseFake(),
        globalAction: GlobalAction.shared,
        globalState: GlobalState.shared
    )
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let wordcheckingViewController = ViewControllerHost(
            WordCheckingViewController().then {
                $0.reactor = self.reactor
                $0.performsDeallocationChecking = false
            }
        )
        
        let navigationController = UINavigationController().then {
            $0.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
            $0.setViewControllers([wordcheckingViewController], animated: false)
        }

        let tabBarController = UITabBarController().then {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            $0.tabBar.standardAppearance = appearance
            $0.viewControllers = [navigationController]
        }
        
        window = UIWindow(windowScene: windowScene).then {
            $0.makeKeyAndVisible()
            $0.rootViewController = tabBarController
        }
    }

}

extension FakeWordUseCase: Then {}
