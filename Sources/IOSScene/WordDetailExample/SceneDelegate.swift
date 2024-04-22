@testable import IOSScene_WordDetail
import UIKit
import UseCase_WordTesting

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var coordinator: WordDetailCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = .init(windowScene: windowScene)
        window?.makeKeyAndVisible()

        let navigationController = UINavigationController()

        window?.rootViewController = navigationController

        let modallyNavigationController = UINavigationController()
        coordinator = WordDetailCoordinator(navigationController: modallyNavigationController, uuid: UUID())
        coordinator?.start()

        navigationController.present(modallyNavigationController, animated: true)
    }
}
