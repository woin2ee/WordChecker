//
//  TranslationSite.swift
//  iOSCore
//
//  Created by Jaewon Yun on 2023/09/21.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation

struct TranslationSite {

    let type: TranslationSiteType

    var translationSourceLanguage: TranslationLanguage?

    var translationTargetLanguage: TranslationLanguage

    func url(forWord word: String) -> String {
        let sourceLanguageCode: String = translationSourceLanguage?.queryParameterForPapago ?? "auto"
        let targetLanguageCode: String = translationTargetLanguage.queryParameterForPapago

        switch type {
        case .papago:
            return "https://papago.naver.com/?sk=\(sourceLanguageCode)&tk=\(targetLanguageCode)&hn=0&st=\(word)"
        }
    }

    init(
        type: TranslationSiteType = .papago,
        translationSourceLanguage: TranslationLanguage? = nil,
        translationTargetLanguage: TranslationLanguage
    ) {
        self.type = type
        self.translationSourceLanguage = translationSourceLanguage
        self.translationTargetLanguage = translationTargetLanguage
    }

}

extension TranslationSite {

    enum TranslationSiteType {

        case papago

    }

}

extension TranslationLanguage {

    var queryParameterForPapago: String {
        switch self {
        case .korean:
            "ko"
        case .english:
            "en"
        case .japanese:
            "ja"
        case .chinese:
            "zh-CN"
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
