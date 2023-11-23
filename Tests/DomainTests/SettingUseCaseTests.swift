//
//  SettingUseCaseTests.swift
//  DomainUnitTests
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

import DataDriverTesting
import Domain
import RxBlocking
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
            try sut.updateTranslationLocale(source: .english, target: .korean)
                .toBlocking()
                .single()

            let currentTranslationLocale = try sut.currentTranslationLocale
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

            let currentTranslationLocale = try sut.currentTranslationLocale
                .toBlocking()
                .single()

            XCTAssertEqual(currentTranslationLocale.source, .korean)
            XCTAssertEqual(currentTranslationLocale.target, .english)
        }
    }

}
