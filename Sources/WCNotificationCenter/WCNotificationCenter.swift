import Foundation
import UserNotifications

final class WCNotificationCenter: WCNotificationCenterProtocol {

    let notificationCenter: UNUserNotificationCenter

    weak var delegate: UNUserNotificationCenterDelegate?

    init(notificationCenter: UNUserNotificationCenter) {
        self.notificationCenter = notificationCenter
    }

    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        return try await notificationCenter.requestAuthorization(options: options)
    }

    func addNotification(identifier: String) async throws {
        let content: UNMutableNotificationContent = .init()
        content.title = "Title"
        content.body = "Body"
        content.subtitle = "Subtitle"

        let triggerDate: DateComponents = .init(hour: 9, minute: 0)

        let trigger: UNCalendarNotificationTrigger = .init(dateMatching: triggerDate, repeats: true)

        let notificationRequest: UNNotificationRequest = .init(identifier: identifier, content: content, trigger: trigger)

        try await notificationCenter.add(notificationRequest)
    }

    func getAllPendingNotifications() async -> [UNNotificationRequest] {
        await notificationCenter.pendingNotificationRequests()
    }

    func getAllDeliveredNotifications() async -> [UNNotification] {
        await notificationCenter.deliveredNotifications()
    }

    func removePendingNotification(withIdentifier identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    func removeAllPendingNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }

}
