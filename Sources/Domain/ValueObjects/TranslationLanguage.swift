//
//  TranslationLocale.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation

public enum TranslationLanguage: CaseIterable, Codable, Sendable {

    case korean

    case english

    case japanese

    case chinese

    case french

    case spanish

    case italian

    case german

    case russian

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

    public var bcp47tag: String {
        switch self {
        case .korean:
            "ko"
        case .english:
            "en"
        case .japanese:
            "ja"
        case .chinese:
            "zh"
        case .french:
            "fr"
        case .spanish:
            "es"
        case .italian:
            "it"
        case .german:
            "de"
        case .russian:
            "ru"
        }
    }

}
