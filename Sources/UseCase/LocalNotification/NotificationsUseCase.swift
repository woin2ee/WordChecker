//
//  NotificationsUseCase.swift
//  Domain
//
//  Created by Jaewon Yun on 1/24/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Domain_LocalNotification
import Domain_Word
import Foundation
import FoundationPlus
import RxSwift
import RxSwiftSugar
import UserNotifications

internal final class NotificationsUseCase: NotificationsUseCaseProtocol {

    let localNotificationService: LocalNotificationService
    let wordService: WordService

    init(localNotificationService: LocalNotificationService, wordService: WordService) {
        self.localNotificationService = localNotificationService
        self.wordService = wordService
    }

    func requestNotificationAuthorization(with options: UNAuthorizationOptions) -> Single<Bool> {
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

    func getNotificationAuthorizationStatus() -> Infallible<UNAuthorizationStatus> {
        return .create { observer in
            Task {
                let notificationSettings = await self.localNotificationService.notificationSettings()
                observer(.next(notificationSettings.authorizationStatus))
                observer(.completed)
            }

            return Disposables.create()
        }
    }

    func setDailyReminder(at time: DateComponents) -> Single<Void> {
        guard let hour = time.hour, let minute = time.minute else {
            return .error(NotificationUseCaseError.noticeTimeInvalid)
        }

        let unmemorizedWordCount = wordService.fetchUnmemorizedWordList().count
        assert(unmemorizedWordCount >= 0)

        let dailyReminder = DailyReminder(
            unmemorizedWordCount: unmemorizedWordCount,
            noticeTime: NoticeTime(hour: hour, minute: minute)
        )

        return .create { observer in
            Task {
                try await self.localNotificationService.setDailyReminder(dailyReminder)
                observer(.success(()))
            } catch: { error in
                observer(.failure(error))
            }
            return Disposables.create()
        }
    }

    func updateDailyReminder() -> RxSwift.Completable {
        return getDailyReminder()
            .map { DateComponents(hour: $0.noticeTime.hour, minute: $0.noticeTime.minute) }
            .flatMap { return self.setDailyReminder(at: $0) }
            .asCompletable()
    }

    func removeDailyReminder() {
        localNotificationService.removeDailyReminder()
    }

    func getDailyReminder() -> Single<DailyReminder> {
        return .create { observer in
            Task {
                guard let dailyReminder = await self.localNotificationService.getPendingDailyReminder() else {
                    observer(.failure(NotificationUseCaseError.noPendingDailyReminder))
                    return
                }

                observer(.success(dailyReminder))
            }

            return Disposables.create()
        }
    }

    func getLatestDailyReminderTime() throws -> DateComponents {
        let noticeTime = try localNotificationService.getLatestDailyReminderTime()
        return DateComponents(hour: noticeTime.hour, minute: noticeTime.minute)
    }
}
