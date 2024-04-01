//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain_UserSettings
import Foundation

enum UserSettingsServiceFakeError: Error {
    case notSavedUserSettings
}

public final class UserSettingsServiceFake: UserSettingsService {

    public var _userSettings: UserSettings?

    public init() {}

    public func saveUserSettings(_ userSettings: Domain_UserSettings.UserSettings) throws {
        _userSettings = userSettings
    }

    public func getUserSettings() throws -> Domain_UserSettings.UserSettings {
        guard let userSettings = _userSettings else {
            throw UserSettingsServiceFakeError.notSavedUserSettings
        }

        return userSettings
    }
}
