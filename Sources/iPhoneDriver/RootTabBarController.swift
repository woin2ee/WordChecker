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

public final class RootTabBarController: UITabBarController {

    public static let shared: RootTabBarController = .init()

    let tabBarItemSymbolConfig: UIImage.SymbolConfiguration = .init(weight: .bold)

    public private(set) lazy var wordCheckingNC: UINavigationController = .init().then {
        $0.tabBarItem = .init(
            title: WCString.memorization,
            image: .init(systemSymbol: .checkmarkDiamond),
            selectedImage: .init(systemSymbol: .checkmarkDiamond, withConfiguration: tabBarItemSymbolConfig)
        )
    }

    public private(set) lazy var wordListNC: UINavigationController = .init().then {
        $0.tabBarItem = .init(
            title: WCString.list,
            image: .init(systemSymbol: .listBullet),
            selectedImage: .init(systemSymbol: .listBullet, withConfiguration: tabBarItemSymbolConfig)
        )
    }

    public private(set) lazy var userSettingsNC: UINavigationController = .init().then {
        $0.tabBarItem = .init(
            title: WCString.settings,
            image: .init(systemSymbol: .gearshape),
            selectedImage: .init(systemSymbol: .gearshape, withConfiguration: tabBarItemSymbolConfig)
        )
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        self.viewControllers = [wordCheckingNC, wordListNC, userSettingsNC]
    }

    func setAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
    }

}
