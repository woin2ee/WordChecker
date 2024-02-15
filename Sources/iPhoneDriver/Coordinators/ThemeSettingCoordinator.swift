import IOSSupport
import SwinjectDIContainer
import SwinjectExtension
import UIKit
import ThemeSetting

final class ThemeSettingCoordinator: BasicCoordinator {

    override func start() {
        let viewController: ThemeSettingViewControllerProtocol = DIContainer.shared.resolver.resolve()
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }

}

extension ThemeSettingCoordinator: ThemeSettingViewControllerDelegate {
}
