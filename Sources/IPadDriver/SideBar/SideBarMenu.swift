//
//  SideBarMenu.swift
//  IPadDriver
//
//  Created by Jaewon Yun on 4/11/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import SFSafeSymbols
import UIKit

internal enum SideBarMenu {

    case wordChecking
    case wordList
    case userSettings

    var title: String {
        switch self {
        case .wordChecking:
            LocalizedString.wordCheckingMenu
        case .wordList:
            LocalizedString.wordListMenu
        case .userSettings:
            LocalizedString.userSettingsMenu
        }
    }
    
    var symbol: UIImage {
        let weightConfig = UIImage.SymbolConfiguration(weight: .bold)
        
        switch self {
        case .wordChecking:
            let symbolConfig = UIImage.SymbolConfiguration(hierarchicalColor: .systemRed)
                .applying(weightConfig)
            return UIImage(systemSymbol: .checkmarkDiamond, withConfiguration: symbolConfig)
        case .wordList:
            let symbolConfig = UIImage.SymbolConfiguration(hierarchicalColor: .systemBlue)
                .applying(weightConfig)
            return UIImage(systemSymbol: .listBullet, withConfiguration: symbolConfig)
        case .userSettings:
            let symbolConfig = UIImage.SymbolConfiguration(hierarchicalColor: .systemGray)
                .applying(weightConfig)
            return UIImage(systemSymbol: .gearshape, withConfiguration: symbolConfig)
        }
    }
}
