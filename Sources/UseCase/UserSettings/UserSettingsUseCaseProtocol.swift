//
//  UserSettingsUseCase.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain_UserSettings
import Foundation
import RxSwift

public protocol UserSettingsUseCase {

    func updateTranslationLocale(source sourceLocale: TranslationLanguage, target targetLocale: TranslationLanguage) -> Single<Void>

    func getCurrentTranslationLocale() -> Single<(source: TranslationLanguage, target: TranslationLanguage)>

    func getCurrentUserSettings() -> Single<UserSettings>

    func onHaptics() -> Single<Void>

    func offHaptics() -> Single<Void>

    func updateThemeStyle(_ style: ThemeStyle) -> Single<Void>

}
