//
//  UserSettingsUseCaseProtocol.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

public protocol UserSettingsUseCaseProtocol {

    var currentUserSettingsRelay: BehaviorRelay<UserSettings?> { get }

    func updateTranslationLocale(source sourceLocale: TranslationLanguage, target targetLocale: TranslationLanguage) -> Single<Void>

    var currentTranslationLocale: Single<(source: TranslationLanguage, target: TranslationLanguage)> { get }

    func initUserSettings() -> Single<UserSettings>

    var currentUserSettings: Single<UserSettings> { get }

}
