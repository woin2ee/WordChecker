//
//  SceneDelegate.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

@testable import IOSScene_UserSettings
import IOSSupport
import RxSwift
import Then
import UIKit
import UseCase_GoogleDriveTesting
import UseCase_UserSettingsTesting

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let delegateProxy: UserSettingsViewControllerDelegate = UserSettingsViewControllerDelegateProxy()
    let disposeBag = DisposeBag()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let viewController = UserSettingsViewController().then {
            $0.reactor = UserSettingsReactor(
                userSettingsUseCase: UserSettingsUseCaseFake(),
                googleDriveUseCase: GoogleDriveUseCaseFake(),
                globalAction: GlobalAction.shared
            )
            $0.delegate = delegateProxy
        }
        
        let navigationController = UINavigationController().then {
            $0.tabBarItem = .init(title: "Settings", image: .init(systemName: "gearshape"), tag: 0)
            $0.setViewControllers([viewController], animated: false)
        }

        let tabBarController = UITabBarController().then {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            $0.tabBar.standardAppearance = appearance
            $0.tabBar.scrollEdgeAppearance = appearance
            $0.viewControllers = [navigationController]
        }
        
        window = UIWindow(windowScene: windowScene).then {
            $0.makeKeyAndVisible()
            $0.rootViewController = tabBarController
        }
    }
}

private final class UserSettingsViewControllerDelegateProxy: UserSettingsViewControllerDelegate {
    
    func didTapSourceLanguageSettingRow() {
        print(#function)
    }
    
    func didTapTargetLanguageSettingRow() {
        print(#function)
    }
    
    func didTapNotificationsSettingRow() {
        print(#function)
    }
    
    func didTapGeneralSettingsRow() {
        print(#function)
    }
}
