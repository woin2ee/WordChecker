//
//  SceneDelegate.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

@testable import IOSScene_WordList
import Inject
import IOSSupport
import Then
import UIKit
import UseCase_WordTesting

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let wordListViewControllerDelegateProxy: WordListViewControllerDelegate = WordListViewControllerDelegateProxy()
    weak var wordListViewController: UIViewController?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        wordListViewController = WordListViewController().then {
            $0.reactor = WordListReactor(
                globalAction: GlobalAction.shared,
                wordUseCase: FakeWordUseCase().then { useCase in
                    (1...50).forEach { number in
                        _ = useCase.addNewWord("Lorem ipsum \(number)").subscribe()
                    }
                }
            )
            $0.delegate = self.wordListViewControllerDelegateProxy
        }

        
        let injectedViewController = Inject.ViewControllerHost(
            self.wordListViewController ?? UIViewController()
        )
        
        let navigationController: UINavigationController = .init()
        navigationController.tabBarItem = .init(title: "Settings", image: .init(systemName: "gearshape"), tag: 0)
        navigationController.setViewControllers([injectedViewController], animated: false)

        let tabBarController: UITabBarController = .init()
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance
        tabBarController.viewControllers = [navigationController]

        window = UIWindow(windowScene: windowScene).then {
            $0.makeKeyAndVisible()
            $0.rootViewController = tabBarController
        }
    }
}

final class WordListViewControllerDelegateProxy: WordListViewControllerDelegate {
    
    func didTapAddWordButton() {
        print(#function)
    }
    
    func didTapWordRow(with uuid: UUID) {
        print(#function)
    }
}

extension FakeWordUseCase: Then {}
