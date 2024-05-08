//
//  UserSettingsUseCaseFake.swift
//  Testing
//
//  Created by Jaewon Yun on 2023/09/19.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain_UserSettings
import Foundation
import RxSwift
import UseCase_UserSettings

public final class UserSettingsUseCaseFake: UserSettingsUseCase {

    public var currentUserSettings: UserSettings = .init(
        translationSourceLocale: .english,
        translationTargetLocale: .korean,
        hapticsIsOn: true,
        themeStyle: .system
    )

    public init() {}

    public func updateTranslationLocale(source sourceLocale: TranslationLanguage, target targetLocale: TranslationLanguage) -> RxSwift.Single<Void> {
        currentUserSettings.translationSourceLocale = sourceLocale
        currentUserSettings.translationTargetLocale = targetLocale

        return .just(())
    }

    public func getCurrentTranslationLocale() -> RxSwift.Single<(source: TranslationLanguage, target: TranslationLanguage)> {
        return .just((
            source: currentUserSettings.translationSourceLocale,
            target: currentUserSettings.translationTargetLocale))
    }

    public func getCurrentUserSettings() -> RxSwift.Single<UserSettings> {
        return .just(currentUserSettings)
    }

    public func onHaptics() -> RxSwift.Single<Void> {
        currentUserSettings.hapticsIsOn = true
        return .just(())
    }

    public func offHaptics() -> RxSwift.Single<Void> {
        currentUserSettings.hapticsIsOn = false
        return .just(())
    }

    public func updateThemeStyle(_ style: ThemeStyle) -> Single<Void> {
        currentUserSettings.themeStyle = style
        return .just(())
    }

    public func changeMemorizingWordSize(fontSize: Domain_UserSettings.MemorizingWordSize) -> RxSwift.Single<Void> {
        currentUserSettings.memorizingWordSize = fontSize
        return .just(())
    }
}
