import Container
import IOSScene_UserSettings
import IOSSupport
import UIKit

internal final class ThemeSettingCoordinator: BasicCoordinator {

    override func start() {
        let viewController: ThemeSettingViewControllerProtocol = container.resolve()
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }

}

extension ThemeSettingCoordinator: ThemeSettingViewControllerDelegate {
}
