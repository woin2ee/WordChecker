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
                themeStyle: .system
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
                themeStyle: .dark
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
}
