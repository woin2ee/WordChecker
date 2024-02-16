//
//  RootTabBarController.swift
//  PushNotificationSettings
//
//  Created by Jaewon Yun on 1/30/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import IOSSupport
import SFSafeSymbols
import Then
import UIKit

/// 앱의 가장 메인이 되는 `TabBarController` 입니다.
///
/// `shared` 타입 프로퍼티를 이용하여 공유 인스턴스를 가져올 수 있습니다.
public final class RootTabBarController: UITabBarController {

    public static let shared: RootTabBarController = .init()

    public private(set) lazy var wordCheckingNC: WordCheckingNavigationController = .init()
    public private(set) lazy var wordListNC: WordListNavigationController = .init()
    public private(set) lazy var userSettingsNC: UserSettingsNavigationController = .init()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        self.viewControllers = [wordCheckingNC, wordListNC, userSettingsNC]
    }

    private func setAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
    }

}
