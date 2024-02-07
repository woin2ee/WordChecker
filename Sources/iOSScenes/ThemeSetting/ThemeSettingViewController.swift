import iOSSupport
import ReactorKit
import UIKit

public protocol ThemeSettingViewControllerDelegate: AnyObject {
    // An example if you use navigation stack.
    func willPopView()
}

public protocol ThemeSettingViewControllerProtocol: UIViewController {
    var delegate: ThemeSettingViewControllerDelegate? { get set }
}

final class ThemeSettingViewController: RxBaseViewController, View, ThemeSettingViewControllerProtocol {

    weak var delegate: ThemeSettingViewControllerDelegate?

    func bind(reactor: ThemeSettingReactor) {

    }

}
