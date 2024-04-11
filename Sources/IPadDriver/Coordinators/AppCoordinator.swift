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

    public static let shared = AppCoordinator(rootSplitViewController: RootSplitViewController(style: .doubleColumn))

    public weak var parentCoordinator: Coordinator?
    public var childCoordinators: [Coordinator] = []

    let rootSplitViewController: RootSplitViewController
    let sideBarViewController: SideBarViewController = SideBarViewController()
    let wordCheckingNC: UINavigationController = UINavigationController()
    let wordListNC: UINavigationController = UINavigationController()
    let userSettingsNC: UINavigationController = UINavigationController()

    private init(rootSplitViewController: RootSplitViewController) {
        self.rootSplitViewController = rootSplitViewController
    }

    public func start() {
        sideBarViewController.menuTableView.delegate = self
        
        let wordCheckingCoordinator = WordCheckingCoordinator(navigationController: wordCheckingNC)
        childCoordinators.append(wordCheckingCoordinator)
        wordCheckingCoordinator.start()
        
        let wordListCoordinator = WordListCoordinator(navigationController: wordListNC)
        childCoordinators.append(wordListCoordinator)
        wordListCoordinator.start()
        
        let userSettingsCoordinator = UserSettingsCoordinator(navigationController: userSettingsNC)
        childCoordinators.append(userSettingsCoordinator)
        userSettingsCoordinator.start()
        
        rootSplitViewController.viewControllers = [sideBarViewController, wordCheckingNC]
    }
}

extension AppCoordinator: UNUserNotificationCenterDelegate {

    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        #warning("Below is temporary workaround for specify indexPath")
        await sideBarViewController.menuTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
        await rootSplitViewController.setViewController(wordCheckingNC, for: .secondary)
    }
}

extension AppCoordinator: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMenu = sideBarViewController.menuList[indexPath.section][indexPath.row]
        switch selectedMenu {
        case .wordChecking:
            rootSplitViewController.setViewController(wordCheckingNC, for: .secondary)
        case .wordList:
            rootSplitViewController.setViewController(wordListNC, for: .secondary)
        case .userSettings:
            rootSplitViewController.setViewController(userSettingsNC, for: .secondary)
        }
    }
}
