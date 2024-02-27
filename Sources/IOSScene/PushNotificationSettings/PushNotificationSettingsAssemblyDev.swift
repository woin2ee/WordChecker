import Foundation
import Swinject
import SwinjectExtension
import Then

public final class PushNotificationSettingsAssemblyDev: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(PushNotificationSettingsReactor.self) { resolver in
            return .init(notificationsUseCase: resolver.resolve(), globalAction: .shared)
        }

        container.register(PushNotificationSettingsViewControllerProtocol.self) { resolver in
            let reactor: PushNotificationSettingsReactor = resolver.resolve()

            return PushNotificationSettingsViewControllerDev.init().then {
                $0.reactor = reactor
            }
        }
    }

}
