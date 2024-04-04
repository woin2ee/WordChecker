import IOSSupport
import RxSwift
import UIKit
import Utility

open class CommonSceneDelegate: UIResponder, UIWindowSceneDelegate {

    let disposeBag: DisposeBag = .init()

    public var window: UIWindow?

    let globalAction: GlobalAction = .shared
    let globalState: GlobalState = .shared

    public func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = .init(windowScene: windowScene)
        window?.makeKeyAndVisible()

        setRootViewController()

        subscribeGlobalState()
    }

    public func sceneWillEnterForeground(_ scene: UIScene) {
        globalAction.sceneWillEnterForeground.accept(())
    }

    public func sceneDidBecomeActive(_ scene: UIScene) {
        globalAction.sceneDidBecomeActive.accept(())
    }
    
    /// `window` 의 `rootViewController` 를 설정합니다.
    ///
    /// 이 메소드는 `UISceneDelegate.scene(_:willConnectTo:options:)` 함수 내에서 `window` 가 초기화 된 후 호출됩니다.
    open func setRootViewController() {
        abstractMethod(message: "You should implement this abstract method in subclasses.")
    }

    func subscribeGlobalState() {
        globalState.themeStyle
            .asDriver()
            .drive(with: self) { owner, userInterfaceStyle in
                owner.window?.overrideUserInterfaceStyle = userInterfaceStyle
            }
            .disposed(by: disposeBag)
    }
}
