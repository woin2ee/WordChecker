//
//  UserSettingsRepositoryProtocol.swift
//  Domain
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Foundation
import RxSwift

public protocol UserSettingsRepositoryProtocol {

    func saveUserSettings(_ userSettings: UserSettings) -> Single<Void>

    func getUserSettings() -> Single<UserSettings>

    func updateLatestDailyReminderTime(_ time: DateComponents) throws

    func getLatestDailyReminderTime() throws -> DateComponents

}
