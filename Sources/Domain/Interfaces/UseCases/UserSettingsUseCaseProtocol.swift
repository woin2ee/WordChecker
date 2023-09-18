//
//  UserSettingsUseCaseProtocol.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import RxSwift

public protocol UserSettingsUseCaseProtocol {

    func updateTranslationLocale(source sourceLocale: TranslationLocale, target targetLocale: TranslationLocale) -> Single<Void>

    var currentTranslationLocale: Single<(source: TranslationLocale, target: TranslationLocale)> { get }

    func initUserSettings() -> Single<UserSettings>

    var currentUserSettings: Single<UserSettings> { get }

}
