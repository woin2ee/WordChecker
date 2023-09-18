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

    public func updateTranslationLocale(source sourceLocale: TranslationLocale, target targetLocale: TranslationLocale) -> RxSwift.Single<Void> {
        return userSettingsRepository.getUserSettings()
            .map { currentSettings in
                var newSettings = currentSettings
                newSettings.translationSourceLocale = sourceLocale
                newSettings.translationTargetLocale = targetLocale
                return newSettings
            }
            .flatMap { self.userSettingsRepository.saveUserSettings($0) }
    }

    public var currentTranslationLocale: RxSwift.Single<(source: TranslationLocale, target: TranslationLocale)> {
        return userSettingsRepository.getUserSettings()
            .map { userSettings -> (source: TranslationLocale, target: TranslationLocale) in
                return (userSettings.translationSourceLocale, userSettings.translationTargetLocale)
            }
    }

    public func initUserSettings() -> RxSwift.Single<UserSettings> {
        var translationTargetLocale: TranslationLocale

        switch Locale.current.language.region?.identifier {
        case "KR":
            translationTargetLocale = .korea
        default:
            translationTargetLocale = .english
        }

        let userSettings: UserSettings = .init(translationSourceLocale: .english, translationTargetLocale: translationTargetLocale) // FIXME: 처음에 Source Locale 설정 가능하게 (현재 .english 고정)

        return userSettingsRepository.saveUserSettings(userSettings)
            .flatMap { self.userSettingsRepository.getUserSettings() }
    }

    public var currentUserSettings: Single<UserSettings> {
        return userSettingsRepository.getUserSettings()
    }

}
