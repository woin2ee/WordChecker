//
//  WordCheckingNavigationController.swift
//  IPhoneDriver
//
//  Created by Jaewon Yun on 2/16/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import IOSSupport
import SFSafeSymbols
import UIKit

public final class WordCheckingNavigationController: UINavigationController {

    /// TabBarItem 만을 초기화한 인스턴스를 생성하여 반환합니다.
    init() {
        super.init(nibName: nil, bundle: nil)

        self.tabBarItem = .init(
            title: WCString.memorization,
            image: .init(systemSymbol: .checkmarkDiamond),
            selectedImage: .init(
                systemSymbol: .checkmarkDiamond,
                withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
            )
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
