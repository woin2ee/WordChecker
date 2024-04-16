import IOSScene_WordDetail
import IOSScene_WordList
import IOSSupport
import SwinjectDIContainer
import SwinjectExtension
import UIKit

final class WordListCoordinator: BasicCoordinator {

    override func start() {
        let viewController: WordListViewControllerProtocol = DIContainer.shared.resolver.resolve()
        viewController.delegate = self
        navigationController?.setViewControllers([viewController], animated: false)
    }
}

extension WordListCoordinator: WordListViewControllerDelegate, WordSearchResultsControllerDelegate {

    func didTapWordRow(with uuid: UUID) {
        let presentedNavigationController: UINavigationController = .init()

        let coordinator: WordDetailCoordinator = .init(navigationController: presentedNavigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start(with: uuid)

        navigationController?.present(presentedNavigationController, animated: true)
    }

    func didTapAddWordButton() {
        let presentedNavigationController: UINavigationController = .init()

        let coordinator: WordAdditionCoordinator = .init(navigationController: presentedNavigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()

        navigationController?.present(presentedNavigationController, animated: true)
    }
}
