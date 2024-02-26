//
//  LocalizedString.swift
//  WordAddition
//
//  Created by Jaewon Yun on 2/25/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation

internal struct LocalizedString {

    private init() {}

    static let tabBarItem1 = String(localized: "Memorization", bundle: .module, comment: "tabBarItem1")
    static let tabBarItem2 = String(localized: "List", bundle: .module, comment: "tabBarItem2")
    static let tabBarItem3 = String(localized: "Settings", bundle: .module, comment: "tabBarItem3")
}
