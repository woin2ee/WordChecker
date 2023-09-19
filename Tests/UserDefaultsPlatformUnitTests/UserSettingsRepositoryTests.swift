//
//  UserSettingsRepositoryTests.swift
//  UserDefaultsPlatformUnitTests
//
//  Created by Jaewon Yun on 2023/09/19.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import UserDefaultsPlatform
import Domain
import RxBlocking
import XCTest

final class UserSettingsRepositoryTests: XCTestCase {

    var sut: UserSettingsRepositoryProtocol!

    override func setUpWithError() throws {
        try super.setUpWithError()

        let wcUserDefaults: WCUserDefaults = .init(_userDefaults: .init(suiteName: #file)!)

        clearWCUserDefaults(wcUserDefaults)

        sut = UserSettingsRepository.init(userDefaults: wcUserDefaults)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
    }

    func testSaveAndGetUserSettings() throws {
        do {
            // Given
            let userSettings: UserSettings = .init(translationSourceLocale: .english, translationTargetLocale: .korea)

            // When
            try sut.saveUserSettings(userSettings)
                .toBlocking()
                .single()

            // Then
            let result = try sut.getUserSettings()
                .toBlocking()
                .single()

            XCTAssertEqual(result.translationSourceLocale, .english)
            XCTAssertEqual(result.translationTargetLocale, .korea)
        }

        do {
            // Given
            let userSettings: UserSettings = .init(translationSourceLocale: .korea, translationTargetLocale: .english)

            // When
            try sut.saveUserSettings(userSettings)
                .toBlocking()
                .single()

            // Then
            let result = try sut.getUserSettings()
                .toBlocking()
                .single()

            XCTAssertEqual(result.translationSourceLocale, .korea)
            XCTAssertEqual(result.translationTargetLocale, .english)
        }
    }

}
