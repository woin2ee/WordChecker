//
//  SettingUseCaseTests.swift
//  DomainUnitTests
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import Domain
import RxBlocking
import Testing
import XCTest

final class SettingUseCaseTests: XCTestCase {

    var sut: UserSettingsUseCaseProtocol!

    override func setUpWithError() throws {
        try super.setUpWithError()

        let userSettingsRepository: UserSettingsRepositoryProtocol = UserSettingsRepositoryFake()

        sut = UserSettingsUseCase.init(userSettingsRepository: userSettingsRepository)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
    }

    func testSetToOtherTranslationLocale() throws {
        // Given
        _ = try sut.initUserSettings()
            .toBlocking()
            .single()

        // Act1
        do {
            try sut.updateTranslationLocale(source: .english, target: .korea)
                .toBlocking()
                .single()

            let currentTranslationLocale = try sut.currentTranslationLocale
                .toBlocking()
                .single()

            XCTAssertEqual(currentTranslationLocale.source, .english)
            XCTAssertEqual(currentTranslationLocale.target, .korea)
        }

        // Act2
        do {
            try sut.updateTranslationLocale(source: .korea, target: .english)
                .toBlocking()
                .single()

            let currentTranslationLocale = try sut.currentTranslationLocale
                .toBlocking()
                .single()

            XCTAssertEqual(currentTranslationLocale.source, .korea)
            XCTAssertEqual(currentTranslationLocale.target, .english)
        }
    }

    func testCurrentTranslationLocaleExistenceAfterInitUserSettings() throws {
        // Given
        _ = try sut.initUserSettings()
            .toBlocking()
            .single()

        // When
        let currentTranslationLocale = try sut.currentTranslationLocale
            .toBlocking()
            .single()

        // Then
        XCTAssertEqual(currentTranslationLocale.target, .english)
    }

}
