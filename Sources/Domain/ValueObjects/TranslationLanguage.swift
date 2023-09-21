//
//  TranslationLocale.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import Localization

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
            WCString.korean
        case .english:
            WCString.english
        case .japanese:
            WCString.japanese
        case .chinese:
            WCString.chinese
        case .french:
            WCString.french
        case .spanish:
            WCString.spanish
        case .italian:
            WCString.italian
        case .german:
            WCString.german
        case .russian:
            WCString.russian
        }
    }

}
