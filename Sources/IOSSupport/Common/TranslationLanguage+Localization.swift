//
//  TranslationLangauge+Localization.swift
//  IOSScene_UserSettings
//
//  Created by Jaewon Yun on 3/15/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Domain_UserSettings
import Foundation

extension TranslationLanguage {

    /// 현재 현지화된 언어로 번역한 명칭을 반환합니다.
    public var localizedString: String {
        switch self {
        case .korean:
            LocalizedString.korean
        case .english:
            LocalizedString.english
        case .japanese:
            LocalizedString.japanese
        case .chinese:
            LocalizedString.chinese
        case .french:
            LocalizedString.french
        case .spanish:
            LocalizedString.spanish
        case .italian:
            LocalizedString.italian
        case .german:
            LocalizedString.german
        case .russian:
            LocalizedString.russian
        }
    }
}
