//
//  TranslationLocale.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain_Core
import Foundation

public enum TranslationLanguage: String, Codable, CaseIterable {

    case korean

    case english

    case japanese

    case chinese

    case french

    case spanish

    case italian

    case german

    case russian
}

extension TranslationLanguage {
    
    public var bcp47tag: BCP47Tag {
        switch self {
        case .korean:
            return .ko
        case .english:
            return .en
        case .japanese:
            return .ja
        case .chinese:
            return .zh
        case .french:
            return .fr
        case .spanish:
            return .es
        case .italian:
            return .it
        case .german:
            return .de
        case .russian:
            return .ru
        }
    }
}
