//
//  UserSettings.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation

public struct UserSettings {

    public var translationTargetLocale: TranslationLocale

    public init(translationTargetLocale: TranslationLocale) {
        self.translationTargetLocale = translationTargetLocale
    }

}
