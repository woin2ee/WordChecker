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

final class UserSettingsRepository: UserSettingsRepositoryProtocol {

    let userDefaults: WCUserDefaults

    init(userDefaults: WCUserDefaults) {
        self.userDefaults = userDefaults
    }

    func saveUserSettings(_ userSettings: Domain.UserSettings) -> RxSwift.Single<Void> {
        return userDefaults.rx.setValue(userSettings.translationTargetLocale, forKey: .translationTargetLocale)
            .mapToVoid()
    }

    func getUserSettings() -> RxSwift.Single<Domain.UserSettings> {
        return userDefaults.rx.object(forKey: .translationTargetLocale)
            .map { $0 as? TranslationTargetLocale }
            .unwrapOrThrow()
            .map { locale -> Domain.UserSettings in
                return .init(translationTargetLocale: locale)
            }
    }

}
