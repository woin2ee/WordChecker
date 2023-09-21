//
//  UserSettings.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation

public struct UserSettings {

    public var translationSourceLocale: TranslationLanguage

    public var translationTargetLocale: TranslationLanguage

    public init(translationSourceLocale: TranslationLanguage, translationTargetLocale: TranslationLanguage) {
        self.translationSourceLocale = translationSourceLocale
        self.translationTargetLocale = translationTargetLocale
    }

}
