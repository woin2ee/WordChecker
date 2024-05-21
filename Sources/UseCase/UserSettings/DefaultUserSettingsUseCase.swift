//
//  DefaultUserSettingsUseCase.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain_UserSettings
import Foundation
import RxSwift
import RxRelay
import RxSwiftSugar
import Utility

internal final class DefaultUserSettingsUseCase: UserSettingsUseCase {

    private let userSettingsService: UserSettingsService

    init(
        userSettingsService: UserSettingsService
    ) {
        self.userSettingsService = userSettingsService

        initUserSettingsIfNoUserSettings()
            .subscribe()
            .dispose()
    }

    func updateTranslationLocale(source sourceLocale: TranslationLanguage, target targetLocale: TranslationLanguage) -> RxSwift.Single<Void> {
        var userSettings: UserSettings
        do {
            userSettings = try userSettingsService.getUserSettings()
        } catch {
            return .error(error)
        }

        userSettings.translationSourceLocale = sourceLocale
        userSettings.translationTargetLocale = targetLocale

        do {
            try userSettingsService.saveUserSettings(userSettings)
        } catch {
            return .error(error)
        }

        return .just(())
    }

    func getCurrentTranslationLocale() -> RxSwift.Single<(source: TranslationLanguage, target: TranslationLanguage)> {
        let userSettings: UserSettings
        do {
            userSettings = try userSettingsService.getUserSettings()
        } catch {
            return .error(error)
        }

        return .just((userSettings.translationSourceLocale, userSettings.translationTargetLocale))
    }

    func getCurrentUserSettings() -> Single<UserSettings> {
        do {
            return .just(try userSettingsService.getUserSettings())
        } catch {
            return .error(error)
        }
    }

    func onHaptics() -> Single<Void> {
        var userSettings: UserSettings
        do {
            userSettings = try userSettingsService.getUserSettings()
        } catch {
            return .error(error)
        }

        userSettings.hapticsIsOn = true

        do {
            try userSettingsService.saveUserSettings(userSettings)
        } catch {
            return .error(error)
        }

        return .just(())
    }

    func offHaptics() -> Single<Void> {
        var userSettings: UserSettings
        do {
            userSettings = try userSettingsService.getUserSettings()
        } catch {
            return .error(error)
        }

        userSettings.hapticsIsOn = false

        do {
            try userSettingsService.saveUserSettings(userSettings)
        } catch {
            return .error(error)
        }

        return .just(())
    }

    func updateThemeStyle(_ style: ThemeStyle) -> Single<Void> {
        var userSettings: UserSettings
        do {
            userSettings = try userSettingsService.getUserSettings()
        } catch {
            return .error(error)
        }

        userSettings.themeStyle = style

        do {
            try userSettingsService.saveUserSettings(userSettings)
        } catch {
            return .error(error)
        }

        return .just(())
    }

    func changeMemorizingWordSize(fontSize: Domain_UserSettings.MemorizingWordSize) -> RxSwift.Single<Void> {
        return .create { observer in
            do {
                var userSettings = try self.userSettingsService.getUserSettings()
                userSettings.memorizingWordSize = fontSize
                try self.userSettingsService.saveUserSettings(userSettings)
                observer(.success(()))
            } catch {
                observer(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    func onAutoCapitalization() -> RxSwift.Single<Void> {
        return .create { [self] observer in
            do {
                var userSettings = try userSettingsService.getUserSettings()
                userSettings.autoCapitalizationIsOn = true
                try userSettingsService.saveUserSettings(userSettings)
                observer(.success(()))
            } catch {
                observer(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    func offAutoCapitalization() -> RxSwift.Single<Void> {
        return .create { [self] observer in
            do {
                var userSettings = try userSettingsService.getUserSettings()
                userSettings.autoCapitalizationIsOn = false
                try userSettingsService.saveUserSettings(userSettings)
                observer(.success(()))
            } catch {
                observer(.failure(error))
            }
            return Disposables.create()
        }
    }
}

// MARK: - Helpers

extension DefaultUserSettingsUseCase {

    private func initUserSettingsIfNoUserSettings() -> RxSwift.Single<Void> {
        guard (try? userSettingsService.getUserSettings()) == nil else {
            return .just(())
        }

        let translationTargetLocale: TranslationLanguage = switch Locale.current.language.region?.identifier {
        case "KR":
            .korean
        case "CN":
            .chinese
        case "FR":
            .french
        case "DE":
            .german
        case "IT":
            .italian
        case "JP":
            .japanese
        case "RU":
            .russian
        case "ES":
            .spanish
        default:
            .english
        }

        // FIXME: 처음에 Source Locale 설정 가능하게 (현재 .english 고정)
        let initialUserSettings: UserSettings = .init(translationSourceLocale: .english, translationTargetLocale: translationTargetLocale, hapticsIsOn: true, themeStyle: .system)

        do {
            try userSettingsService.saveUserSettings(initialUserSettings)
            return .just(())
        } catch {
            return .error(error)
        }
    }
}
