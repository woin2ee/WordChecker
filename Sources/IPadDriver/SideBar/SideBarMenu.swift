//
//  SideBarMenu.swift
//  IPadDriver
//
//  Created by Jaewon Yun on 4/11/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

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
}
