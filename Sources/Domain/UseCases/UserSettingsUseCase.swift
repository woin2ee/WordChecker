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

    public func setTranslationLocale(to newLocale: TranslationTargetLocale) -> RxSwift.Single<Void> {
        return userSettingsRepository.getUserSettings()
            .map { currentSettings in
                var newSettings = currentSettings
                newSettings.translationTargetLocale = newLocale
                return newSettings
            }
            .flatMap { self.userSettingsRepository.saveUserSettings($0) }
    }

    public var currentTranslationLocale: RxSwift.Single<TranslationTargetLocale> {
        return userSettingsRepository.getUserSettings()
            .map(\.translationTargetLocale)
    }

}
