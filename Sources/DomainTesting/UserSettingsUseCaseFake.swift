//
//  UserSettingsUseCaseFake.swift
//  Testing
//
//  Created by Jaewon Yun on 2023/09/19.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import Domain

import Foundation
import RxSwift
import RxRelay
import UserNotifications

public final class UserSettingsUseCaseFake: UserSettingsUseCaseProtocol {

    public var currentUserSettings: Domain.UserSettings = .init(
        translationSourceLocale: .english,
        translationTargetLocale: .korean
    )

    public var _dailyReminder: UNNotificationRequest?
    public var dailyReminderIsRemoved: Bool = true

    public init() {}

    public func updateTranslationLocale(source sourceLocale: Domain.TranslationLanguage, target targetLocale: Domain.TranslationLanguage) -> RxSwift.Single<Void> {
        currentUserSettings.translationSourceLocale = sourceLocale
        currentUserSettings.translationTargetLocale = targetLocale

        return .just(())
    }

    public func getCurrentTranslationLocale() -> RxSwift.Single<(source: Domain.TranslationLanguage, target: Domain.TranslationLanguage)> {
        return .just((
            source: currentUserSettings.translationSourceLocale,
            target: currentUserSettings.translationTargetLocale))
    }

    public func getCurrentUserSettings() -> RxSwift.Single<Domain.UserSettings> {
        return .just(currentUserSettings)
    }

    public func setDailyReminder(at time: DateComponents) -> RxSwift.Single<Void> {
        dailyReminderIsRemoved = false

        let trigger: UNCalendarNotificationTrigger = .init(dateMatching: time, repeats: true)
        _dailyReminder = .init(identifier: "Test", content: .init(), trigger: trigger)
        return .just(())
    }

    public func removeDailyReminder() {
        dailyReminderIsRemoved = true
    }

    public func getDailyReminder() -> RxSwift.Single<UNNotificationRequest> {
        if dailyReminderIsRemoved {
            return .error(UserSettingsUseCaseError.notSetDailyReminder)
        }

        guard let dailyReminder = _dailyReminder else {
            return .error(UserSettingsUseCaseError.notSetDailyReminder)
        }

        return .just(dailyReminder)
    }

    public func updateDailyReminerTime(to time: DateComponents) -> RxSwift.Single<Void> {
        if dailyReminderIsRemoved {
            return .error(UserSettingsUseCaseError.notSetDailyReminder)
        }

        let trigger: UNCalendarNotificationTrigger = .init(dateMatching: time, repeats: true)
        _dailyReminder = .init(identifier: "Test", content: .init(), trigger: trigger)
        return .just(())
    }

    public func getLatestDailyReminderTime() throws -> DateComponents {
        guard let trigger = _dailyReminder?.trigger as? UNCalendarNotificationTrigger else {
            throw UserSettingsUseCaseError.notSetDailyReminder
        }

        return trigger.dateComponents
    }

}
