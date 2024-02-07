import iOSSupport
import SwinjectDIContainer
import SwinjectExtension
import UIKit
import ThemeSetting

final class ThemeSettingCoordinator: Coordinator {

    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        // An example if you use navigation stack.
        let viewController: ThemeSettingViewControllerProtocol = DIContainer.shared.resolver.resolve()
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }

    /* If you want start to coordinator with arguments.
    func start<Arg1>(with argument: Arg1) {

    }
    */

}

extension ThemeSettingCoordinator: ThemeSettingViewControllerDelegate {

    // An example if you use navigation stack.
    func willPopView() {
        navigationController.popViewController(animated: true)
        parentCoordinator?.childCoordinators.removeAll(where: { $0 === self })
    }

}
