//
//  UserSettingsUseCaseFake.swift
//  Testing
//
//  Created by Jaewon Yun on 2023/09/19.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import Domain

import Foundation
import RxSwift

public final class UserSettingsUseCaseFake: UserSettingsUseCaseProtocol {

    public var currentUserSettings: Domain.UserSettings = .init(
        translationSourceLocale: .english,
        translationTargetLocale: .korean
    )

    public init() {}

    public func updateTranslationLocale(source sourceLocale: Domain.TranslationLanguage, target targetLocale: Domain.TranslationLanguage) -> RxSwift.Single<Void> {
        currentUserSettings.translationSourceLocale = sourceLocale
        currentUserSettings.translationTargetLocale = targetLocale

        return .just(())
    }

    public func getCurrentTranslationLocale() -> RxSwift.Single<(source: Domain.TranslationLanguage, target: Domain.TranslationLanguage)> {
        return .just((
            source: currentUserSettings.translationSourceLocale,
            target: currentUserSettings.translationTargetLocale))
    }

    public func getCurrentUserSettings() -> RxSwift.Single<Domain.UserSettings> {
        return .just(currentUserSettings)
    }

}
