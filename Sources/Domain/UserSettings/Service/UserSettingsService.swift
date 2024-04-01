//
//  UserSettingsService.swift
//  Domain_Notification
//
//  Created by Jaewon Yun on 3/20/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import ExtendedUserDefaults
import Foundation
import Utility

public protocol UserSettingsService {
    func saveUserSettings(_ userSettings: UserSettings) throws
    func getUserSettings() throws -> UserSettings
}

internal final class UserDefaultsUserSettingsService: UserSettingsService {

    let userDefaults: ExtendedUserDefaults

    init(userDefaults: ExtendedUserDefaults) {
        self.userDefaults = userDefaults
    }

    func saveUserSettings(_ userSettings: UserSettings) throws {
        try userDefaults.setCodable(
            userSettings.translationSourceLocale,
            forKey: UserDefaultsKey.translationSourceLocale)
        .get()
        try userDefaults.setCodable(
            userSettings.translationTargetLocale,
            forKey: UserDefaultsKey.translationTargetLocale
        ).get()
        userDefaults.setValue(userSettings.hapticsIsOn, forKey: UserDefaultsKey.hapticsIsOn)
        try userDefaults.setCodable(userSettings.themeStyle, forKey: UserDefaultsKey.themeStyle).get()
    }

    func getUserSettings() throws -> UserSettings {
        let translationSourceLocale = try userDefaults.object(TranslationLanguage.self, forKey: UserDefaultsKey.translationSourceLocale).get()
        let translationTargetLocale = try userDefaults.object(TranslationLanguage.self, forKey: UserDefaultsKey.translationTargetLocale).get()
        let hapticsIsOn = try unwrapOrThrow(userDefaults.bool(forKey: UserDefaultsKey.hapticsIsOn))
        let themeStyle = try userDefaults.object(ThemeStyle.self, forKey: UserDefaultsKey.themeStyle).get()

        return UserSettings(
            translationSourceLocale: translationSourceLocale,
            translationTargetLocale: translationTargetLocale,
            hapticsIsOn: hapticsIsOn,
            themeStyle: themeStyle
        )
    }
}
