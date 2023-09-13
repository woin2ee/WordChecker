//
//  AppTabBarController.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/14.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import UIKit

public final class AppTabBarController: UITabBarController {

    public init() {
        super.init(nibName: nil, bundle: nil)
        
        let symbolWeightConfig: UIImage.SymbolConfiguration = .init(weight: .bold)

        let wordListVC: WordListViewController = DIContainer.shared.resolve()
        let wordListNC: UINavigationController = .init(rootViewController: wordListVC)
        wordListNC.tabBarItem = .init(
            title: WCString.list,
            image: .init(systemSymbol: .listBullet),
            selectedImage: .init(systemSymbol: .listBullet, withConfiguration: symbolWeightConfig)
        )
        
        let wordCheckingVC: WordCheckingViewController = DIContainer.shared.resolve(argument: wordListVC.viewModel as? WordCheckingViewModelDelegate)
        let wordCheckingNC: UINavigationController = .init(rootViewController: wordCheckingVC)
        wordCheckingNC.tabBarItem = .init(
            title: WCString.memorization,
            image: .init(systemSymbol: .checkmarkDiamond),
            selectedImage: .init(systemSymbol: .checkmarkDiamond, withConfiguration: symbolWeightConfig)
        )

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        self.viewControllers = [wordCheckingNC, wordListNC]
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
