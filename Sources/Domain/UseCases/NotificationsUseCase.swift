//
//  NotificationsUseCase.swift
//  Domain
//
//  Created by Jaewon Yun on 1/24/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation
import FoundationPlus
import RxSwift
import RxUtility
import UserNotifications

final class NotificationsUseCase: NotificationsUseCaseProtocol {

    /// Notification request 의 고유 ID
    let DAILY_REMINDER_NOTIFICATION_ID: String = "DailyReminder"

    let localNotificationService: LocalNotificationService
    let wordRepository: WordRepositoryProtocol
    let userSettingsRepository: UserSettingsRepositoryProtocol

    init(localNotificationService: LocalNotificationService, wordRepository: WordRepositoryProtocol, userSettingsRepository: UserSettingsRepositoryProtocol) {
        self.localNotificationService = localNotificationService
        self.wordRepository = wordRepository
        self.userSettingsRepository = userSettingsRepository
    }

    public func requestNotificationAuthorization(with options: UNAuthorizationOptions) -> Single<Bool> {
        return .create { observer in
            Task {
                let hasAuthorization = try await self.localNotificationService.requestAuthorization(options: options)
                observer(.success(hasAuthorization))
            } catch: { error in
                observer(.failure(error))
            }

            return Disposables.create()
        }
    }

    public func getNotificationAuthorizationStatus() -> Single<UNAuthorizationStatus> {
        return .create { observer in
            Task {
                let notificationSettings = await self.localNotificationService.notificationSettings()
                observer(.success(notificationSettings.authorizationStatus))
            }

            return Disposables.create()
        }
    }

    public func setDailyReminder(at time: DateComponents) -> Single<Void> {
        let setDailyReminderSequence: Single<Void> = .create { observer in
            let unmemorizedWordCount = self.wordRepository.getUnmemorizedList().count

            var content: UNMutableNotificationContent = .init()
            content.title = DomainString.daily_reminder
            content.sound = .default

            if unmemorizedWordCount == 0 {
                content.body = DomainString.daily_reminder_body_message_when_no_words_to_memorize
            } else {
                content.body = DomainString.daily_reminder_body_message(unmemorizedWordCount: unmemorizedWordCount)
            }

            let trigger: UNCalendarNotificationTrigger = .init(dateMatching: time, repeats: true)
            let notificationRequest: UNNotificationRequest = .init(
                identifier: self.DAILY_REMINDER_NOTIFICATION_ID,
                content: content,
                trigger: trigger
            )

            do {
                try self.localNotificationService.saveLatestDailyReminderTime(time)
            } catch {
                // TODO: 예외 상황 로그 추가
            }

            Task {
                try await self.localNotificationService.add(notificationRequest)
                observer(.success(()))
            } catch: { error in
                observer(.failure(error))
            }

            return Disposables.create()
        }
            .subscribe(on: ConcurrentMainScheduler.instance)

        return self.getNotificationAuthorizationStatus()
            .flatMap { authorizationStatus in
                if authorizationStatus == .authorized {
                    return setDailyReminderSequence
                } else {
                    return .error(UserSettingsUseCaseError.noNotificationAuthorization)
                }
            }
    }

    public func updateDailyReminder() -> RxSwift.Completable {
        return getDailyReminder()
            .map { ($0.trigger as? UNCalendarNotificationTrigger)?.dateComponents }
            .unwrapOrThrow()
            .flatMap { return self.setDailyReminder(at: $0) }
            .asCompletable()
    }

    public func removeDailyReminder() {
        localNotificationService.removePendingNotificationRequests(withIdentifiers: [DAILY_REMINDER_NOTIFICATION_ID])
    }

    public func getDailyReminder() -> Single<UNNotificationRequest> {
        return .create { observer in
            Task {
                guard let dailyReminder = await self.localNotificationService.pendingNotificationRequests()
                    .filter({ $0.identifier == self.DAILY_REMINDER_NOTIFICATION_ID })
                    .first
                else {
                    observer(.failure(UserSettingsUseCaseError.noPendingDailyReminder))
                    return
                }

                observer(.success(dailyReminder))
            }

            return Disposables.create()
        }
    }

    public func getLatestDailyReminderTime() throws -> DateComponents {
        return try localNotificationService.getLatestDailyReminderTime()
    }

}
