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

}
