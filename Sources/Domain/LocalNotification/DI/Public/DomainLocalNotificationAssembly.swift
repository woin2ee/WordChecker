import ExtendedUserDefaults
import Swinject
import UserNotifications

public final class DomainLocalNotificationAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(LocalNotificationService.self) { _ in
            return DefaultLocalNotificationService(
                userDefaults: .standard,
                userNotificationCenter: .current()
            )
        }
        .inObjectScope(.container)
    }
}
