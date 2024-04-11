import IOSDriver
import UIKit

final class SceneDelegate: CommonSceneDelegate {

    let appCoordinator: AppCoordinator = .shared
    
    override func setRootViewController() {
        self.window?.rootViewController = appCoordinator.rootSplitViewController
        appCoordinator.start()
    }
}
