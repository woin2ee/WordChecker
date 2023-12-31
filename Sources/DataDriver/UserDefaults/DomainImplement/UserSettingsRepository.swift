//
//  UserSettingsRepository.swift
//  Data
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import ExtendedUserDefaults
import ExtendedUserDefaultsRxExtension
import Foundation
import RxSwift
import RxUtility

final class UserSettingsRepository: UserSettingsRepositoryProtocol {

    let userDefaults: ExtendedUserDefaults

    init(userDefaults: ExtendedUserDefaults) {
        self.userDefaults = userDefaults
    }

    func saveUserSettings(_ userSettings: Domain.UserSettings) -> RxSwift.Single<Void> {
        return Single.zip(
            userDefaults.rx.setCodable(
                userSettings.translationSourceLocale,
                forKey: UserDefaultsKey.translationSourceLocale
            ),
            userDefaults.rx.setCodable(
                userSettings.translationTargetLocale,
                forKey: UserDefaultsKey.translationTargetLocale
            )
        )
        .mapToVoid()
    }

    func getUserSettings() -> RxSwift.Single<Domain.UserSettings> {
        return Single.zip(
            userDefaults.rx.object(TranslationLanguage.self, forKey: UserDefaultsKey.translationSourceLocale),
            userDefaults.rx.object(TranslationLanguage.self, forKey: UserDefaultsKey.translationTargetLocale)
        )
        .map { sourceLocale, targetLocale -> Domain.UserSettings in
            return .init(translationSourceLocale: sourceLocale, translationTargetLocale: targetLocale)
        }
    }

}
