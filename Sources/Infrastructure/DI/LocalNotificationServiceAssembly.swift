import Domain
import Swinject
import UserNotifications

final class LocalNotificationServiceAssembly: Assembly {

    func assemble(container: Container) {
        container.register(Domain.LocalNotificationService.self) { _ in
            return UserNotifications.UNUserNotificationCenter.current()
        }
        .inObjectScope(.container)
    }

}
