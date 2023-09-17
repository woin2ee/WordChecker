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
        // Act1
        do {
            try sut.setTranslationLocale(to: .korea)
                .toBlocking()
                .single()

            let currentTranslationLocale = try sut.currentTranslationLocale
                .toBlocking()
                .single()

            XCTAssertEqual(currentTranslationLocale, .korea)
        }

        // Act2
        do {
            try sut.setTranslationLocale(to: .english)
                .toBlocking()
                .single()

            let currentTranslationLocale = try sut.currentTranslationLocale
                .toBlocking()
                .single()

            XCTAssertEqual(currentTranslationLocale, .english)
        }
    }

}
