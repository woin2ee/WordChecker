//
//  OldUserSettings.swift
//  Domain_UserSettings
//
//  Created by Jaewon Yun on 4/23/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Domain_UserSettings
import Foundation

struct OldUserSettings: Codable {
    var translationSourceLocale: TranslationLanguage
    var translationTargetLocale: TranslationLanguage
    var hapticsIsOn: Bool
    var themeStyle: ThemeStyle
    
    init(translationSourceLocale: TranslationLanguage, translationTargetLocale: TranslationLanguage, hapticsIsOn: Bool, themeStyle: ThemeStyle) {
        self.translationSourceLocale = translationSourceLocale
        self.translationTargetLocale = translationTargetLocale
        self.hapticsIsOn = hapticsIsOn
        self.themeStyle = themeStyle
    }
}
