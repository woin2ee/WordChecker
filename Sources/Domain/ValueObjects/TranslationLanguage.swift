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
            DomainString.korean
        case .english:
            DomainString.english
        case .japanese:
            DomainString.japanese
        case .chinese:
            DomainString.chinese
        case .french:
            DomainString.french
        case .spanish:
            DomainString.spanish
        case .italian:
            DomainString.italian
        case .german:
            DomainString.german
        case .russian:
            DomainString.russian
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
