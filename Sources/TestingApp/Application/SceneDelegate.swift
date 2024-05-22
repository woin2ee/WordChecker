import Inject
import Then
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let mainViewController = ViewControllerHost(MainViewController())
        
        window = UIWindow(windowScene: windowScene).then {
            $0.makeKeyAndVisible()
            $0.rootViewController = mainViewController
        }
    }
}
