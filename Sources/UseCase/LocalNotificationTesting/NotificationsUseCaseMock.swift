//
//  NotificationsUseCaseMock.swift
//  DomainTesting
//
//  Created by Jaewon Yun on 1/24/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Domain_LocalNotification
import Foundation
import RxSwift
import UserNotifications
@testable import UseCase_LocalNotification

public final class NotificationsUseCaseMock: NotificationsUseCase {

    public var updateDailyReminderCallCount: Int = 0
    public var _authorizationStatus: UNAuthorizationStatus = .notDetermined
    public var expectedAuthorizationStatus: UNAuthorizationStatus = .notDetermined
    public var _dailyReminder: DailyReminder?
    public var dailyReminderIsRemoved: Bool = true

    public init(expectedAuthorizationStatus: UNAuthorizationStatus) {
        self.expectedAuthorizationStatus = expectedAuthorizationStatus
    }

    public func setDailyReminder(at time: DateComponents) -> RxSwift.Single<Void> {
        if _authorizationStatus != .authorized {
            return .error(NotificationUseCaseError.noNotificationAuthorization)
        }

        dailyReminderIsRemoved = false

        guard let hour = time.hour, let minute = time.minute else {
            return .error(NotificationUseCaseError.noticeTimeInvalid)
        }

        _dailyReminder = .init(
            unmemorizedWordCount: 10,
            noticeTime: NoticeTime(hour: hour, minute: minute)
        )
        return .just(())
    }

    public func updateDailyReminder() -> RxSwift.Completable {
        updateDailyReminderCallCount += 1

        guard
            _authorizationStatus == .authorized,
            dailyReminderIsRemoved == false,
            let dailyReminder = _dailyReminder
        else {
            return .error(NotificationUseCaseError.noPendingDailyReminder)
        }

        let date = DateComponents(hour: dailyReminder.noticeTime.hour, minute: dailyReminder.noticeTime.minute)

        return setDailyReminder(at: date)
            .asCompletable()
    }

    public func removeDailyReminder() {
        dailyReminderIsRemoved = true
    }

    public func getDailyReminder() -> RxSwift.Single<DailyReminder> {
        guard
            _authorizationStatus == .authorized,
            dailyReminderIsRemoved == false,
            let dailyReminder = _dailyReminder
        else {
            return .error(NotificationUseCaseError.noPendingDailyReminder)
        }

        return .just(dailyReminder)
    }

    public func getLatestDailyReminderTime() throws -> DateComponents {
        guard let dailyReminder = _dailyReminder else {
            throw NotificationUseCaseError.noPendingDailyReminder
        }
        return DateComponents(hour: dailyReminder.noticeTime.hour, minute: dailyReminder.noticeTime.minute)
    }

    /// Test - 현재 인증 상태를 미리 설정한 예상 인증 상태(`expectedAuthorizationStatus`)로 설정하고 `UNAuthorizationOptions.authorized` 일때만 true 를 방출합니다.
    public func requestNotificationAuthorization(with options: UNAuthorizationOptions) -> RxSwift.Single<Bool> {
        _authorizationStatus = expectedAuthorizationStatus

        if _authorizationStatus == .authorized {
            return .just(true)
        }

        return .just(false)
    }

    public func getNotificationAuthorizationStatus() -> RxSwift.Infallible<UNAuthorizationStatus> {
        return .just(_authorizationStatus)
    }

}
