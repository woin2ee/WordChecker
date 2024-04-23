@testable import Domain_UserSettings

import ExtendedUserDefaults
import XCTest

final class UserDefaultsUserSettingsServiceTests: XCTestCase {

    var sut: UserDefaultsUserSettingsService!

    override func setUpWithError() throws {
        try super.setUpWithError()

        let userDefaults: ExtendedUserDefaults = .init(suiteName: #file)!
        userDefaults.removeAllObject(forKeyType: UserDefaultsKey.self)

        sut = UserDefaultsUserSettingsService(userDefaults: userDefaults)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
    }

    func testSaveAndGetUserSettings() throws {
        // First attempt
        do {
            // Given
            let userSettings: UserSettings = .init(
                translationSourceLocale: .english,
                translationTargetLocale: .korean,
                hapticsIsOn: true,
                themeStyle: .system, 
                memorizingWordSize: .default
            )

            // When
            try sut.saveUserSettings(userSettings)

            // Then
            let result = try sut.getUserSettings()

            XCTAssertEqual(result.translationSourceLocale, .english)
            XCTAssertEqual(result.translationTargetLocale, .korean)
            XCTAssertEqual(result.hapticsIsOn, true)
            XCTAssertEqual(result.themeStyle, .system)
        }
        
        // Second attempt
        do {
            // Given
            let userSettings: UserSettings = .init(
                translationSourceLocale: .korean,
                translationTargetLocale: .english,
                hapticsIsOn: false,
                themeStyle: .dark,
                memorizingWordSize: .default
            )

            // When
            try sut.saveUserSettings(userSettings)

            // Then
            let result = try sut.getUserSettings()

            XCTAssertEqual(result.translationSourceLocale, .korean)
            XCTAssertEqual(result.translationTargetLocale, .english)
            XCTAssertEqual(result.hapticsIsOn, false)
            XCTAssertEqual(result.themeStyle, .dark)
        }
    }
    
    func test_getUserSettings_whenUpdatedUserSettings() throws {
        // Given
        let oldUserSettings = OldUserSettings(
            translationSourceLocale: .chinese,
            translationTargetLocale: .english,
            hapticsIsOn: true,
            themeStyle: .system
        )
        let userDefauls = ExtendedUserDefaults(suiteName: "Temporary")!
        userDefauls.setCodable(oldUserSettings, forKey: UserDefaultsKey.userSettings)
        sut = UserDefaultsUserSettingsService(userDefaults: userDefauls)
        
        // When
        let newUserSettings = try sut.getUserSettings()
        
        // Then
        XCTAssertEqual(newUserSettings.translationSourceLocale, oldUserSettings.translationSourceLocale)
        XCTAssertEqual(newUserSettings.translationTargetLocale, oldUserSettings.translationTargetLocale)
        XCTAssertEqual(newUserSettings.hapticsIsOn, oldUserSettings.hapticsIsOn)
        XCTAssertEqual(newUserSettings.themeStyle, oldUserSettings.themeStyle)
    }
}
