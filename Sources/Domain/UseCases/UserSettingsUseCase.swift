//
//  UserSettingsUseCase.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxUtility
import Then
import UserNotifications
import Utility

protocol UserNotificationCenter {
    func add(_ request: UNNotificationRequest) async throws
    func removePendingNotificationRequests(withIdentifiers identifiers: [String])
}

public final class UserSettingsUseCase: UserSettingsUseCaseProtocol {

    let dailyReminderNotificationID: String = "DailyReminder"

    let userSettingsRepository: UserSettingsRepositoryProtocol
    let notificationCenter: UserNotificationCenter

    init(
        userSettingsRepository: UserSettingsRepositoryProtocol,
        notificationCenter: UserNotificationCenter
    ) {
        self.userSettingsRepository = userSettingsRepository
        self.notificationCenter = notificationCenter

        initUserSettingsIfNoUserSettings()
            .subscribe()
            .dispose()
    }

    public func updateTranslationLocale(source sourceLocale: TranslationLanguage, target targetLocale: TranslationLanguage) -> RxSwift.Single<Void> {
        return userSettingsRepository.getUserSettings()
            .map { currentSettings in
                var newSettings = currentSettings
                newSettings.translationSourceLocale = sourceLocale
                newSettings.translationTargetLocale = targetLocale
                return newSettings
            }
            .flatMap { self.userSettingsRepository.saveUserSettings($0) }
    }

    public func getCurrentTranslationLocale() -> RxSwift.Single<(source: TranslationLanguage, target: TranslationLanguage)> {
        return userSettingsRepository.getUserSettings()
            .map { userSettings -> (source: TranslationLanguage, target: TranslationLanguage) in
                return (userSettings.translationSourceLocale, userSettings.translationTargetLocale)
            }
    }

    public func getCurrentUserSettings() -> Single<UserSettings> {
        return userSettingsRepository.getUserSettings()
    }

    public func setDailyReminder(at time: DateComponents) -> Single<Void> {
        let content: UNMutableNotificationContent = .init().then {
            // TODO: Content 설정
            $0.title = "Title"
        }
        let trigger: UNCalendarNotificationTrigger = .init(dateMatching: time, repeats: true)
        let request: UNNotificationRequest = .init(
            identifier: self.dailyReminderNotificationID,
            content: content,
            trigger: trigger
        )

        do {
            try userSettingsRepository.updateLatestDailyReminderTime(time)
        } catch {
            // TODO: 예외 상황 로그 추가
        }

        return .create { observer in
            Task {
                try await self.notificationCenter.add(request)
                observer(.success(()))
            } catch: { error in
                observer(.failure(error))
            }

            return Disposables.create()
        }
    }

    public func removeDailyReminder() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [dailyReminderNotificationID])
    }

    public func updateDailyReminerTime(to time: DateComponents) -> Single<Void> {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [dailyReminderNotificationID])

        return self.setDailyReminder(at: time)
    }

    public func getLatestDailyReminderTime() throws -> DateComponents {
        return try userSettingsRepository.getLatestDailyReminderTime()
    }

    func initUserSettingsIfNoUserSettings() -> RxSwift.Single<Void> {
        return userSettingsRepository.getUserSettings()
            .mapToVoid()
            .catch { _ in
                var translationTargetLocale: TranslationLanguage

                switch Locale.current.language.region?.identifier {
                case "KR":
                    translationTargetLocale = .korean
                case "CN":
                    translationTargetLocale = .chinese
                case "FR":
                    translationTargetLocale = .french
                case "DE":
                    translationTargetLocale = .german
                case "IT":
                    translationTargetLocale = .italian
                case "JP":
                    translationTargetLocale = .japanese
                case "RU":
                    translationTargetLocale = .russian
                case "ES":
                    translationTargetLocale = .spanish
                default:
                    translationTargetLocale = .english
                }

                let userSettings: UserSettings = .init(translationSourceLocale: .english, translationTargetLocale: translationTargetLocale) // FIXME: 처음에 Source Locale 설정 가능하게 (현재 .english 고정)

                return self.userSettingsRepository.saveUserSettings(userSettings)
            }
    }

}

enum UserSettingsUseCaseError: Error {
    case notAddedDailyReminderNotification
}
