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

    static let theme = NSLocalizedString("theme", bundle: Bundle.module, comment: "")
    static let system_mode = NSLocalizedString("system_mode", bundle: Bundle.module, comment: "")
    static let light_mode = NSLocalizedString("light_mode", bundle: Bundle.module, comment: "")
    static let dark_mode = NSLocalizedString("dark_mode", bundle: Bundle.module, comment: "")
}
