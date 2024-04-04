import IOSScene_UserSettings
import IOSScene_WordChecking
import IOSSupport
import SFSafeSymbols
import Then
import UIKit

/// 여러 상태에 따라 앱의 초기 `RootViewController` 를 설정합니다.
///
/// 앱의 시작은 이 `Coordinator` 의 `start()` 함수 호출로부터 시작됩니다.
///
/// 이 Coordinator 는 iPad 에 종속적이게 정의되었습니다.
public final class AppCoordinator: NSObject, Coordinator {

    public static let shared = AppCoordinator(rootSplitViewController: UISplitViewController())

    public weak var parentCoordinator: Coordinator?
    public var childCoordinators: [Coordinator] = []

    let rootSplitViewController: UISplitViewController

    private init(rootSplitViewController: UISplitViewController) {
        self.rootSplitViewController = rootSplitViewController
    }

    public func start() {
        fatalError("Not implemented.")
    }

}

extension AppCoordinator: UNUserNotificationCenterDelegate {

    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {

    }
}
