import Swinject
import SwinjectExtension
import Then

internal final class ThemeSettingAssembly: Assembly {

    func assemble(container: Container) {
        container.register(ThemeSettingReactor.self) { resolver in
            return ThemeSettingReactor.init(
                userSettingsUseCase: resolver.resolve(),
                globalState: .shared
            )
        }

        container.register(ThemeSettingViewControllerProtocol.self) { resolver in
            return ThemeSettingViewController().then {
                $0.reactor = resolver.resolve()
            }
        }
    }

}
