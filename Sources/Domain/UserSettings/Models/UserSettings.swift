//
//  UserSettings.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation

public struct UserSettings: Codable {

    /// 변역 원본 언어
    public var translationSourceLocale: TranslationLanguage

    /// 번역 목표 언어
    public var translationTargetLocale: TranslationLanguage

    /// 진동 사용 여부
    public var hapticsIsOn: Bool

    /// 테마 스타일
    public var themeStyle: ThemeStyle

    public init(translationSourceLocale: TranslationLanguage, translationTargetLocale: TranslationLanguage, hapticsIsOn: Bool, themeStyle: ThemeStyle) {
        self.translationSourceLocale = translationSourceLocale
        self.translationTargetLocale = translationTargetLocale
        self.hapticsIsOn = hapticsIsOn
        self.themeStyle = themeStyle
    }

}
