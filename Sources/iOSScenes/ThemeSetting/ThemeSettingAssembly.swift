import Swinject
import SwinjectExtension
import Then

public final class ThemeSettingAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(ThemeSettingReactor.self) { _ in
            return ThemeSettingReactor.init()
        }

        container.register(ThemeSettingViewControllerProtocol.self) { resolver in
            return ThemeSettingViewController().then {
                $0.reactor = resolver.resolve()
            }
        }
    }

}
