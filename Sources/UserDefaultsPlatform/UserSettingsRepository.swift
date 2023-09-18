//
//  UserSettingsRepository.swift
//  Data
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import RxSwift
import RxUtility

public final class UserSettingsRepository: UserSettingsRepositoryProtocol {

    let userDefaults: WCUserDefaults

    public init(userDefaults: WCUserDefaults) {
        self.userDefaults = userDefaults
    }

    public func saveUserSettings(_ userSettings: Domain.UserSettings) -> RxSwift.Single<Void> {
        return Single.zip(
            userDefaults.rx.setCodable(userSettings.translationSourceLocale, forKey: .translationSourceLocale),
            userDefaults.rx.setCodable(userSettings.translationTargetLocale, forKey: .translationTargetLocale)
        )
        .mapToVoid()
    }

    public func getUserSettings() -> RxSwift.Single<Domain.UserSettings> {
        return Single.zip(
            userDefaults.rx.object(TranslationLocale.self, forKey: .translationSourceLocale),
            userDefaults.rx.object(TranslationLocale.self, forKey: .translationTargetLocale)
        )
        .map { sourceLocale, targetLocale -> Domain.UserSettings in
            return .init(translationSourceLocale: sourceLocale, translationTargetLocale: targetLocale)
        }
    }

}
