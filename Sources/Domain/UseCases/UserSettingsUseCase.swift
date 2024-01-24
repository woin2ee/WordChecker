//
//  UserSettingsUseCase.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxUtility
import Utility

public final class UserSettingsUseCase: UserSettingsUseCaseProtocol {

    let userSettingsRepository: UserSettingsRepositoryProtocol

    init(
        userSettingsRepository: UserSettingsRepositoryProtocol
    ) {
        self.userSettingsRepository = userSettingsRepository

        initUserSettingsIfNoUserSettings()
            .subscribe()
            .dispose()
    }

    public func updateTranslationLocale(source sourceLocale: TranslationLanguage, target targetLocale: TranslationLanguage) -> RxSwift.Single<Void> {
        return userSettingsRepository.getUserSettings()
            .map { currentSettings in
                var newSettings = currentSettings
                newSettings.translationSourceLocale = sourceLocale
                newSettings.translationTargetLocale = targetLocale
                return newSettings
            }
            .flatMap { self.userSettingsRepository.saveUserSettings($0) }
    }

    public func getCurrentTranslationLocale() -> RxSwift.Single<(source: TranslationLanguage, target: TranslationLanguage)> {
        return userSettingsRepository.getUserSettings()
            .map { userSettings -> (source: TranslationLanguage, target: TranslationLanguage) in
                return (userSettings.translationSourceLocale, userSettings.translationTargetLocale)
            }
    }

    public func getCurrentUserSettings() -> Single<UserSettings> {
        return userSettingsRepository.getUserSettings()
    }

    func initUserSettingsIfNoUserSettings() -> RxSwift.Single<Void> {
        return userSettingsRepository.getUserSettings()
            .mapToVoid()
            .catch { _ in
                var translationTargetLocale: TranslationLanguage

                switch Locale.current.language.region?.identifier {
                case "KR":
                    translationTargetLocale = .korean
                case "CN":
                    translationTargetLocale = .chinese
                case "FR":
                    translationTargetLocale = .french
                case "DE":
                    translationTargetLocale = .german
                case "IT":
                    translationTargetLocale = .italian
                case "JP":
                    translationTargetLocale = .japanese
                case "RU":
                    translationTargetLocale = .russian
                case "ES":
                    translationTargetLocale = .spanish
                default:
                    translationTargetLocale = .english
                }

                let userSettings: UserSettings = .init(translationSourceLocale: .english, translationTargetLocale: translationTargetLocale) // FIXME: 처음에 Source Locale 설정 가능하게 (현재 .english 고정)

                return self.userSettingsRepository.saveUserSettings(userSettings)
            }
    }

}

enum UserSettingsUseCaseError: Error {
    case noPendingDailyReminder
    case noNotificationAuthorization
}
