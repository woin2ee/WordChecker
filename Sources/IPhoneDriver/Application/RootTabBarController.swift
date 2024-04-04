//
//  RootTabBarController.swift
//  PushNotificationSettings
//
//  Created by Jaewon Yun on 1/30/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import UIKit

/// 앱의 가장 메인이 되는 `TabBarController` 입니다.
///
/// `shared` 타입 프로퍼티를 이용하여 공유 인스턴스를 가져올 수 있습니다.
internal final class RootTabBarController: UITabBarController {

    static let shared: RootTabBarController = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
    }

    private func setAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
    }
}
