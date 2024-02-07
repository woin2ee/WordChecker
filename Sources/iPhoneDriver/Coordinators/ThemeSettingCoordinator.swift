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
        let viewController: ThemeSettingViewControllerProtocol = DIContainer.shared.resolver.resolve()
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }

}

extension ThemeSettingCoordinator: ThemeSettingViewControllerDelegate {

    func willPopView() {
        navigationController.popViewController(animated: true)
        parentCoordinator?.childCoordinators.removeAll(where: { $0 === self })
    }

}
