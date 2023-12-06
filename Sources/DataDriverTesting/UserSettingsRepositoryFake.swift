//
//  UserSettingsRepositoryFake.swift
//  Testing
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import Foundation
import RxSwift

enum UserSettingsRepositoryError: Error {

    case notSavedUserSettings
    case notSavedLatestDailyReminderTime

}

public final class UserSettingsRepositoryFake: UserSettingsRepositoryProtocol {

    public var _userSettings: UserSettings?

    public var _latestDailyReminderTime: DateComponents?

    public init() {}

    public func saveUserSettings(_ userSettings: Domain.UserSettings) -> RxSwift.Single<Void> {
        return .create { result in
            self._userSettings = userSettings
            result(.success(()))
            return Disposables.create()
        }
    }

    public func getUserSettings() -> RxSwift.Single<Domain.UserSettings> {
        return .create { result in
            if let userSettings = self._userSettings {
                result(.success(userSettings))
            } else {
                result(.failure(UserSettingsRepositoryError.notSavedUserSettings))
            }

            return Disposables.create()
        }
    }

    public func updateLatestDailyReminderTime(_ time: DateComponents) throws {
        _latestDailyReminderTime = time
    }

    public func getLatestDailyReminderTime() throws -> DateComponents {
        guard let latestDailyReminderTime = _latestDailyReminderTime else {
            throw UserSettingsRepositoryError.notSavedLatestDailyReminderTime
        }

        return latestDailyReminderTime
    }

}
