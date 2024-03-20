//
//  NotificationsUseCaseProtocol.swift
//  Domain
//
//  Created by Jaewon Yun on 1/24/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import Domain_LocalNotification
import Foundation
import RxSwift
import UserNotifications

public protocol NotificationsUseCaseProtocol {

    /// Requests the user’s authorization to allow local and remote notifications for your app.
    func requestNotificationAuthorization(with options: UNAuthorizationOptions) -> Single<Bool>

    /// Retrieves the notification authorization status for your app.
    func getNotificationAuthorizationStatus() -> Infallible<UNAuthorizationStatus>

    /// 지정한 시각에 매일 알림을 설정합니다.
    /// - Parameter time: 매일 알림을 지정할 시각
    /// - Parameter unmemorizedWordCount: 알림에서 보여질 외우지 못한 단어의 갯수
    /// - Returns: 알림을 정상적으로 설정한 경우 Success 요소를 방출하는 시퀀스를 반환합니다. 어떠한 이유로 알림을 지정하지 못한 경우 Error 를 방출하는 시퀀스를 반환합니다.
    func setDailyReminder(at time: DateComponents) -> Single<Void>

    /// 현재 단어 갯수를 적용하여 알림 내용을 최신화합니다.
    ///
    /// 매일 알림이 설정되어 있지 않거나 정상적으로 알림을 최신화하지 못했을 경우 Error 를 방출합니다.
    func updateDailyReminder() -> Completable

    /// 설정된 매일 알림을 삭제합니다.
    func removeDailyReminder()

    /// 설정되어 있는 매일 알림을 방출하는 시퀀스를 반환합니다.
    /// - Returns: 설정된 매일 알림이 있는 경우 알림 객체를 반환합니다. 설정된 매일 알림이 없거나 알림이 꺼져있는 경우 `error` 이벤트를 방출합니다.
    func getDailyReminder() -> Single<DailyReminder>

    /// 마지막으로 설정한 매일 알림의 시간을 반환합니다.
    ///
    /// - throws: 한 번도 매일 알림을 설정한 적이 없을 때 error를 던집니다.
    func getLatestDailyReminderTime() throws -> DateComponents

}
