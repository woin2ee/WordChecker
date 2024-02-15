//
//  UserSettingsRepositoryTests.swift
//  UserDefaultsPlatformUnitTests
//
//  Created by Jaewon Yun on 2023/09/19.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import Infrastructure

import Domain
import ExtendedUserDefaults
import RxBlocking
import XCTest

final class UserSettingsRepositoryTests: XCTestCase {

    var sut: UserSettingsRepositoryProtocol!

    override func setUpWithError() throws {
        try super.setUpWithError()

        let userDefaults: ExtendedUserDefaults = .init(suiteName: #file)!
        userDefaults.removeAllObject(forKeyType: UserDefaultsKey.self)

        sut = UserSettingsRepository.init(userDefaults: userDefaults)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
    }

    func testSaveAndGetUserSettings() throws {
        do {
            // Given
            let userSettings: UserSettings = .init(translationSourceLocale: .english, translationTargetLocale: .korean, hapticsIsOn: true, themeStyle: .system)

            // When
            try sut.saveUserSettings(userSettings)
                .toBlocking()
                .single()

            // Then
            let result = try sut.getUserSettings()
                .toBlocking()
                .single()

            XCTAssertEqual(result.translationSourceLocale, .english)
            XCTAssertEqual(result.translationTargetLocale, .korean)
            XCTAssertEqual(result.hapticsIsOn, true)
            XCTAssertEqual(result.themeStyle, .system)
        }

        do {
            // Given
            let userSettings: UserSettings = .init(translationSourceLocale: .korean, translationTargetLocale: .english, hapticsIsOn: false, themeStyle: .dark)

            // When
            try sut.saveUserSettings(userSettings)
                .toBlocking()
                .single()

            // Then
            let result = try sut.getUserSettings()
                .toBlocking()
                .single()

            XCTAssertEqual(result.translationSourceLocale, .korean)
            XCTAssertEqual(result.translationTargetLocale, .english)
            XCTAssertEqual(result.hapticsIsOn, false)
            XCTAssertEqual(result.themeStyle, .dark)
        }
    }

}
