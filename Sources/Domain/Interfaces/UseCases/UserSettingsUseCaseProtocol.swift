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

public protocol UserSettingsUseCaseProtocol {

    func updateTranslationLocale(source sourceLocale: TranslationLanguage, target targetLocale: TranslationLanguage) -> Single<Void>

    func getCurrentTranslationLocale() -> Single<(source: TranslationLanguage, target: TranslationLanguage)>

    func getCurrentUserSettings() -> Single<UserSettings>

    /// 지정한 시각에 매일 알림을 설정합니다.
    func setDailyReminder(at time: DateComponents) -> Single<Void>

    /// 설정된 매일 알림을 삭제합니다.
    func removeDailyReminder()

    /// 현재 등록되어 있는 매일 알림의 시간을 변경합니다.
    /// - Parameter time: 변경할 시간
    func updateDailyReminerTime(to time: DateComponents) -> Single<Void>

    /// 마지막으로 설정한 매일 알림의 시간을 반환합니다.
    func getLatestDailyReminderTime() throws -> DateComponents

}
