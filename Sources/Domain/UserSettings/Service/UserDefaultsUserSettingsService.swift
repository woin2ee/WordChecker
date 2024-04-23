import ExtendedUserDefaults
import Foundation
import Utility

public protocol UserSettingsService {
    func saveUserSettings(_ userSettings: UserSettings) throws
    func getUserSettings() throws -> UserSettings
}

internal final class UserDefaultsUserSettingsService: UserSettingsService {

    let userDefaults: ExtendedUserDefaults

    init(userDefaults: ExtendedUserDefaults) {
        self.userDefaults = userDefaults
    }

    func saveUserSettings(_ userSettings: UserSettings) throws {
        try userDefaults.setCodable(userSettings, forKey: UserDefaultsKey.userSettings).get()
    }

    func getUserSettings() throws -> UserSettings {
        return try userDefaults.object(UserSettings.self, forKey: UserDefaultsKey.userSettings).get()
    }
}
