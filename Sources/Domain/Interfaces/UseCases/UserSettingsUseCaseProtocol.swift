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

    func setTranslationLocale(to locale: TranslationTargetLocale) -> Single<Void>

    var currentTranslationLocale: Single<TranslationTargetLocale> { get }

    func initUserSettings() -> Single<UserSettings>

    var currentUserSettings: Single<UserSettings> { get }

}
