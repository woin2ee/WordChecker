import ExtendedUserDefaults
import Swinject
import UserNotifications

public final class DomainLocalNotificationAssembly: Assembly {

    public init() {}
    
    public func assemble(container: Container) {
        container.register(LocalNotificationServiceProtocol.self) { _ in
            return LocalNotificationService(
                userDefaults: .standard,
                userNotificationCenter: .current()
            )
        }
        .inObjectScope(.container)
    }
}
