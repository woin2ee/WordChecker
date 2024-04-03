//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import UseCase_UserSettings

import Domain_UserSettingsTesting
import RxBlocking
import XCTest

final class DefaultUserSettingsUseCaseTests: XCTestCase {

    var sut: DefaultUserSettingsUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = DefaultUserSettingsUseCase(userSettingsService: UserSettingsServiceFake())
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
    }

    func testSetToOtherTranslationLocale() throws {
        // Act1
        do {
            try sut.updateTranslationLocale(source: .english, target: .korean)
                .toBlocking()
                .single()

            let currentTranslationLocale = try sut.getCurrentTranslationLocale()
                .toBlocking()
                .single()

            XCTAssertEqual(currentTranslationLocale.source, .english)
            XCTAssertEqual(currentTranslationLocale.target, .korean)
        }

        // Act2
        do {
            try sut.updateTranslationLocale(source: .korean, target: .english)
                .toBlocking()
                .single()

            let currentTranslationLocale = try sut.getCurrentTranslationLocale()
                .toBlocking()
                .single()

            XCTAssertEqual(currentTranslationLocale.source, .korean)
            XCTAssertEqual(currentTranslationLocale.target, .english)
        }
    }

    func test_onOffHaptics() throws {
        // Given
        let hapticsIsOn = try sut.getCurrentUserSettings()
            .map(\.hapticsIsOn)
            .toBlocking()
            .single()
        XCTAssertEqual(hapticsIsOn, true) // Default value

        // Off
        do {
            // When
            try sut.offHaptics()
                .toBlocking()
                .single()

            // Then
            let hapticsIsOn = try sut.getCurrentUserSettings()
                .map(\.hapticsIsOn)
                .toBlocking()
                .single()
            XCTAssertEqual(hapticsIsOn, false)
        }

        // On
        do {
            // When
            try sut.onHaptics()
                .toBlocking()
                .single()

            // Then
            let hapticsIsOn = try sut.getCurrentUserSettings()
                .map(\.hapticsIsOn)
                .toBlocking()
                .single()
            XCTAssertEqual(hapticsIsOn, true)
        }
    }
}
