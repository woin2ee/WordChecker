//
//  AppDelegate.swift
//  WordChecker
//
//  Created by Jaewon Yun on 2023/08/23.
//

import IOSScene_WordDetail
import SwinjectDIContainer
import UIKit
import UseCase_WordTesting

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        DIContainer.shared.assembler.apply(assemblies: [
            WordDetailAssembly(),
            WordUseCaseFakeAssembly(),
        ])

        return true
    }

}
