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
        return userDefaults.rx.setCodable(userSettings.translationTargetLocale, forKey: .translationTargetLocale)
            .mapToVoid()
    }

    public func getUserSettings() -> RxSwift.Single<Domain.UserSettings> {
        return userDefaults.rx.object(TranslationTargetLocale.self, forKey: .translationTargetLocale)
            .map { locale -> Domain.UserSettings in
                return .init(translationTargetLocale: locale)
            }
    }

}
