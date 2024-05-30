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
    
    func test_getUserSettings_whenOldUserSettings() throws {
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
        let newUserSettingsMirror = Mirror(reflecting: newUserSettings)
        XCTAssertEqual(newUserSettingsMirror.children.count, 6)
        
        let properties = newUserSettingsMirror.children.map(\.label)
        let expectedProperties = [
            "translationSourceLocale",
            "translationTargetLocale",
            "hapticsIsOn",
            "themeStyle",
            "memorizingWordSize",
            "autoCapitalizationIsOn",
        ]
        let values = newUserSettingsMirror.children.map(\.value)
        let expectedValues: [Any] = [
            TranslationLanguage.chinese,
            TranslationLanguage.english,
            true,
            ThemeStyle.system,
            MemorizingWordSize.default,
            true,
        ]
        
        XCTAssertEqual(properties, expectedProperties)
        XCTAssertEqual(values[0] as! TranslationLanguage, expectedValues[0] as! TranslationLanguage)
        XCTAssertEqual(values[1] as! TranslationLanguage, expectedValues[1] as! TranslationLanguage)
        XCTAssertEqual(values[2] as! Bool, expectedValues[2] as! Bool)
        XCTAssertEqual(values[3] as! ThemeStyle, expectedValues[3] as! ThemeStyle)
        XCTAssertEqual(values[4] as! MemorizingWordSize, expectedValues[4] as! MemorizingWordSize)
        XCTAssertEqual(values[5] as! Bool, expectedValues[5] as! Bool)
    }
}
