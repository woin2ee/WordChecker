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
    
    /// 암기 단어 사이즈
    public var memorizingWordSize: MemorizingWordSize
    
    /// 자동 대문자 변환
    public var autoCapitalizationIsOn: Bool

    public init(
        translationSourceLocale: TranslationLanguage,
        translationTargetLocale: TranslationLanguage,
        hapticsIsOn: Bool,
        themeStyle: ThemeStyle,
        memorizingWordSize: MemorizingWordSize = .default,
        autoCapitalizationIsOn: Bool = true
    ) {
        self.translationSourceLocale = translationSourceLocale
        self.translationTargetLocale = translationTargetLocale
        self.hapticsIsOn = hapticsIsOn
        self.themeStyle = themeStyle
        self.memorizingWordSize = memorizingWordSize
        self.autoCapitalizationIsOn = autoCapitalizationIsOn
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.translationSourceLocale = try container.decode(TranslationLanguage.self, forKey: .translationSourceLocale)
        self.translationTargetLocale = try container.decode(TranslationLanguage.self, forKey: .translationTargetLocale)
        self.hapticsIsOn = try container.decode(Bool.self, forKey: .hapticsIsOn)
        self.themeStyle = try container.decode(ThemeStyle.self, forKey: .themeStyle)
        do {
            self.memorizingWordSize = try container.decode(MemorizingWordSize.self, forKey: .memorizingWordSize)
        } catch {
            self.memorizingWordSize = .default
        }
        
        do {
            self.autoCapitalizationIsOn = try container.decode(Bool.self, forKey: .autoCapitalizationIsOn)
        } catch {
            self.autoCapitalizationIsOn = true
        }
        
    }
}
