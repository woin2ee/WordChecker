//
//  UserSettingsUseCaseFake.swift
//  Testing
//
//  Created by Jaewon Yun on 2023/09/19.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import RxSwift
import RxRelay

public final class UserSettingsUseCaseFake: UserSettingsUseCaseProtocol {

    public var currentUserSettingsRelay: RxRelay.BehaviorRelay<Domain.UserSettings?> = .init(value: nil)

    public init() {}

    public func updateTranslationLocale(source sourceLocale: Domain.TranslationLanguage, target targetLocale: Domain.TranslationLanguage) -> RxSwift.Single<Void> {
        guard var currentUserSettings = currentUserSettingsRelay.value else {
            fatalError("UserSettings 이 초기화되지 않았습니다. initUserSettings() 함수를 호출하여 초기화 해야합니다.")
        }

        currentUserSettings.translationSourceLocale = sourceLocale
        currentUserSettings.translationTargetLocale = targetLocale

        currentUserSettingsRelay.accept(currentUserSettings)

        return .just(())
    }

    public var currentTranslationLocale: RxSwift.Single<(source: Domain.TranslationLanguage, target: Domain.TranslationLanguage)> {
        guard let currentUserSettings = currentUserSettingsRelay.value else {
            fatalError("UserSettings 이 초기화되지 않았습니다. initUserSettings() 함수를 호출하여 초기화 해야합니다.")
        }

        return .just((
            source: currentUserSettings.translationSourceLocale,
            target: currentUserSettings.translationTargetLocale))
    }

    public func initUserSettings() -> RxSwift.Single<Domain.UserSettings> {
        let initUserSettings: UserSettings = .init(
            translationSourceLocale: .english,
            translationTargetLocale: .korean
        )
        currentUserSettingsRelay = .init(value: initUserSettings)

        return .just(initUserSettings)
    }

    public var currentUserSettings: RxSwift.Single<Domain.UserSettings> {
        guard let currentUserSettings = currentUserSettingsRelay.value else {
            fatalError("UserSettings 이 초기화되지 않았습니다. initUserSettings() 함수를 호출하여 초기화 해야합니다.")
        }

        return .just(currentUserSettings)
    }

}
