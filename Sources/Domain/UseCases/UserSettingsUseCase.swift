//
//  UserSettingsUseCase.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import RxSwift

public final class UserSettingsUseCase: UserSettingsUseCaseProtocol {

    let userSettingsRepository: UserSettingsRepositoryProtocol

    public init(userSettingsRepository: UserSettingsRepositoryProtocol) {
        self.userSettingsRepository = userSettingsRepository
    }

    public func updateTranslationTargetLocale(to newLocale: TranslationLocale) -> RxSwift.Single<Void> {
        return userSettingsRepository.getUserSettings()
            .map { currentSettings in
                var newSettings = currentSettings
                newSettings.translationTargetLocale = newLocale
                return newSettings
            }
            .flatMap { self.userSettingsRepository.saveUserSettings($0) }
    }

    public var currentTranslationTargetLocale: RxSwift.Single<TranslationLocale> {
        return userSettingsRepository.getUserSettings()
            .map(\.translationTargetLocale)
    }

    public func initUserSettings() -> RxSwift.Single<UserSettings> {
        var translationTargetLocale: TranslationLocale

        switch Locale.current.language.region?.identifier {
        case "KR":
            translationTargetLocale = .korea
        default:
            translationTargetLocale = .english
        }

        let userSettings: UserSettings = .init(translationTargetLocale: translationTargetLocale)

        return userSettingsRepository.saveUserSettings(userSettings)
            .flatMap { self.userSettingsRepository.getUserSettings() }
    }

    public var currentUserSettings: Single<UserSettings> {
        return userSettingsRepository.getUserSettings()
    }

}
