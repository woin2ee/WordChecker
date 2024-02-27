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

    let tabBarItemSymbolConfig: UIImage.SymbolConfiguration = .init(weight: .bold)

    public private(set) lazy var wordCheckingNC: UINavigationController = .init().then {
        $0.tabBarItem = .init(
            title: LocalizedString.tabBarItem1,
            image: .init(systemSymbol: .checkmarkDiamond),
            selectedImage: .init(systemSymbol: .checkmarkDiamond, withConfiguration: tabBarItemSymbolConfig)
        )
    }

    public private(set) lazy var wordListNC: UINavigationController = .init().then {
        $0.tabBarItem = .init(
            title: LocalizedString.tabBarItem2,
            image: .init(systemSymbol: .listBullet),
            selectedImage: .init(systemSymbol: .listBullet, withConfiguration: tabBarItemSymbolConfig)
        )
    }

    public private(set) lazy var userSettingsNC: UINavigationController = .init().then {
        $0.tabBarItem = .init(
            title: LocalizedString.tabBarItem3,
            image: .init(systemSymbol: .gearshape),
            selectedImage: .init(systemSymbol: .gearshape, withConfiguration: tabBarItemSymbolConfig)
        )
    }

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
