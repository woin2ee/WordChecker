import Swinject
import SwinjectExtension

internal final class MainWindowAssembly: Assembly {

    func assemble(container: Container) {
        container.register(MainView.self) { _ in
            return MainView()
        }
        container.register(MainViewController.self) { resolver in
            return MainViewController(
                ownView: resolver.resolve(),
                wordUseCase: resolver.resolve()
            )
        }
        container.register(MainWindow.self) { resolver in
            return MainWindow(mainViewController: resolver.resolve())
        }
    }
}
