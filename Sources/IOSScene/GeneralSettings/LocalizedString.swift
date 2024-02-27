//
//  LocalizedString.swift
//  GeneralSettings
//
//  Created by Jaewon Yun on 2/25/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation

internal struct LocalizedString {

    private init() {}

    static let general = NSLocalizedString("general", bundle: Bundle.module, comment: "")
    static let haptics = NSLocalizedString("haptics", bundle: Bundle.module, comment: "")
    static let theme = NSLocalizedString("theme", bundle: Bundle.module, comment: "")

    static let hapticsSettingsFooterTextWhenHapticsIsOn = NSLocalizedString("hapticsSettingsFooterTextWhenHapticsIsOn", bundle: Bundle.module, comment: "")
    static let hapticsSettingsFooterTextWhenHapticsIsOff = NSLocalizedString("hapticsSettingsFooterTextWhenHapticsIsOff", bundle: Bundle.module, comment: "")
}
