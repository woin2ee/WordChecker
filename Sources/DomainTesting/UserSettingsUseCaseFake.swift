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

    public var _authorizationStatus: UNAuthorizationStatus = .notDetermined
    public var expectedAuthorizationStatus: UNAuthorizationStatus = .notDetermined
    public var _dailyReminder: UNNotificationRequest?
    public var dailyReminderIsRemoved: Bool = true

    public init(expectedAuthorizationStatus: UNAuthorizationStatus) {
        self.expectedAuthorizationStatus = expectedAuthorizationStatus
    }

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
        if _authorizationStatus != .authorized {
            return .error(UserSettingsUseCaseError.noNotificationAuthorization)
        }

        dailyReminderIsRemoved = false

        let trigger: UNCalendarNotificationTrigger = .init(dateMatching: time, repeats: true)
        _dailyReminder = .init(identifier: "Test", content: .init(), trigger: trigger)
        return .just(())
    }

    public func removeDailyReminder() {
        dailyReminderIsRemoved = true
    }

    public func getDailyReminder() -> RxSwift.Single<UNNotificationRequest> {
        guard
            _authorizationStatus == .authorized,
            dailyReminderIsRemoved == false,
            let dailyReminder = _dailyReminder
        else {
            return .error(UserSettingsUseCaseError.noPendingDailyReminder)
        }

        return .just(dailyReminder)
    }

    public func getLatestDailyReminderTime() throws -> DateComponents {
        guard let trigger = _dailyReminder?.trigger as? UNCalendarNotificationTrigger else {
            throw UserSettingsUseCaseError.noPendingDailyReminder
        }

        return trigger.dateComponents
    }

    /// Test - 현재 인증 상태를 미리 설정한 예상 인증 상태(`expectedAuthorizationStatus`)로 설정하고 `UNAuthorizationOptions.authorized` 일때만 true 를 방출합니다.
    public func requestNotificationAuthorization(with options: UNAuthorizationOptions) -> RxSwift.Single<Bool> {
        _authorizationStatus = expectedAuthorizationStatus

        if _authorizationStatus == .authorized {
            return .just(true)
        }

        return .just(false)
    }

    public func getNotificationAuthorizationStatus() -> RxSwift.Single<UNAuthorizationStatus> {
        return .just(_authorizationStatus)
    }

}
