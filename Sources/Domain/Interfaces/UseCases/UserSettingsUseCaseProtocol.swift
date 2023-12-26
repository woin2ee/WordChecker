//
//  UserSettingsUseCaseProtocol.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import UserNotifications

public protocol UserSettingsUseCaseProtocol {

    func updateTranslationLocale(source sourceLocale: TranslationLanguage, target targetLocale: TranslationLanguage) -> Single<Void>

    func getCurrentTranslationLocale() -> Single<(source: TranslationLanguage, target: TranslationLanguage)>

    func getCurrentUserSettings() -> Single<UserSettings>

    /// Requests the user’s authorization to allow local and remote notifications for your app.
    func requestNotificationAuthorization(with options: UNAuthorizationOptions) -> Single<Bool>

    /// Retrieves the notification authorization status for your app.
    ///
    /// 이 함수가 반환하는 Single 시퀀스는 error 를 방출하지 않습니다.
    func getNotificationAuthorizationStatus() -> Single<UNAuthorizationStatus>

    /// 지정한 시각에 매일 알림을 설정합니다.
    func setDailyReminder(at time: DateComponents) -> Single<Void>

    /// 설정된 매일 알림을 삭제합니다.
    func removeDailyReminder()

    /// 설정되어 있는 매일 알림을 방출하는 시퀀스를 반환합니다.
    /// - Returns: 설정된 매일 알림이 있는 경우 알림 객체를 반환합니다. 설정된 매일 알림이 없는 경우 `error` 이벤트를 방출합니다.
    func getDailyReminder() -> Single<UNNotificationRequest>

    /// 마지막으로 설정한 매일 알림의 시간을 반환합니다.
    func getLatestDailyReminderTime() throws -> DateComponents

}
