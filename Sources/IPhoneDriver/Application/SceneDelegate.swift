//
//  SceneDelegate.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import IOSDriver
import UIKit

final class SceneDelegate: CommonSceneDelegate {
    
    let appCoordinator: AppCoordinator = .shared
    
    override func setRootViewController() {
        self.window?.rootViewController = appCoordinator.rootTabBarController
        appCoordinator.start()
    }
}
