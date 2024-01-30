//
//  NotificationsUseCaseProtocol.swift
//  Domain
//
//  Created by Jaewon Yun on 1/24/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Foundation
import RxSwift
import UserNotifications

public protocol NotificationsUseCaseProtocol {

    /// Requests the user’s authorization to allow local and remote notifications for your app.
    func requestNotificationAuthorization(with options: UNAuthorizationOptions) -> Single<Bool>

    /// Retrieves the notification authorization status for your app.
    ///
    /// 이 함수가 반환하는 Single 시퀀스는 error 를 방출하지 않습니다.
    func getNotificationAuthorizationStatus() -> Single<UNAuthorizationStatus>

    /// 지정한 시각에 매일 알림을 설정합니다.
    func setDailyReminder(at time: DateComponents) -> Single<Void>

    /// 현재 단어 갯수를 적용하여 알림 내용을 다시 설정합니다.
    ///
    /// 매일 알림이 설정되어 있지 않거나 정상적으로 알림을 다시 설정하지 못했을 경우 Error 를 방출합니다.
    func resetDailyReminder() -> Completable

    /// 설정된 매일 알림을 삭제합니다.
    func removeDailyReminder()

    /// 설정되어 있는 매일 알림을 방출하는 시퀀스를 반환합니다.
    /// - Returns: 설정된 매일 알림이 있는 경우 알림 객체를 반환합니다. 설정된 매일 알림이 없거나 알림이 꺼져있는 경우 `error` 이벤트를 방출합니다.
    func getDailyReminder() -> Single<UNNotificationRequest>

    /// 마지막으로 설정한 매일 알림의 시간을 반환합니다.
    func getLatestDailyReminderTime() throws -> DateComponents

}
