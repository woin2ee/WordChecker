import Domain_Word
@testable import IOSScene_WordDetail
import IOSSupport
import Then
import UIKit
import UseCase_WordTesting

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let delegateProxy: WordDetailViewControllerDelegate = WordDetailViewControllerDelegateProxy()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let uuid = UUID()
        
        let viewController = WordDetailViewController().then {
            $0.reactor = WordDetailReactor(
                uuid: uuid,
                globalAction: GlobalAction.shared,
                wordUseCase: WordUseCaseFake().then {
                    let word = try! Word(uuid: uuid, word: "Testing", memorizationState: .memorizing)
                    try! $0.addNewWord(word)
                }
            )
            $0.delegate = delegateProxy
        }
        
        let modallyNavigationController = UINavigationController().then {
            $0.setViewControllers([viewController], animated: false)
        }

        let navigationController = UINavigationController().then {
            $0.view.backgroundColor = .systemBackground
        }
        
        window = UIWindow(windowScene: windowScene).then {
            $0.makeKeyAndVisible()
            $0.rootViewController = navigationController
        }
        
        navigationController.present(modallyNavigationController, animated: true)
    }
}

private final class WordDetailViewControllerDelegateProxy: WordDetailViewControllerDelegate {
    
    func viewControllerDidPop(_ viewController: UIViewController) {
        print(#function)
    }
    
    func viewControllerMustBeDismissed(_ viewController: UIViewController) {
        print(#function)
    }
    
    func viewControllerDidDismiss(_ viewController: UIViewController) {
        print(#function)
    }
}

extension WordUseCaseFake: Then {}
