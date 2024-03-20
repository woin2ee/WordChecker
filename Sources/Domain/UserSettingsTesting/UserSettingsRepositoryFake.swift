//
//  UserSettingsRepositoryFake.swift
//  Testing
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain_UserSettings
import Foundation
import RxSwift

enum UserSettingsRepositoryError: Error {

    case notSavedUserSettings
    case notSavedLatestDailyReminderTime

}

public final class UserSettingsRepositoryFake {

    public var _userSettings: UserSettings?

    public init() {}

    public func saveUserSettings(_ userSettings: UserSettings) -> RxSwift.Single<Void> {
        return .create { result in
            self._userSettings = userSettings
            result(.success(()))
            return Disposables.create()
        }
    }

    public func getUserSettings() -> RxSwift.Single<UserSettings> {
        return .create { result in
            if let userSettings = self._userSettings {
                result(.success(userSettings))
            } else {
                result(.failure(UserSettingsRepositoryError.notSavedUserSettings))
            }

            return Disposables.create()
        }
    }

}
