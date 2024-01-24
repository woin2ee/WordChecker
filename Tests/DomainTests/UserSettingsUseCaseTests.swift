//
//  UserSettingsUseCaseTests.swift
//  DomainUnitTests
//
//  Created by Jaewon Yun on 2023/09/17.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import Domain

import DataDriverTesting
import RxBlocking
import XCTest

final class UserSettingsUseCaseTests: XCTestCase {

    var sut: UserSettingsUseCaseProtocol!

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = UserSettingsUseCase.init(
            userSettingsRepository: UserSettingsRepositoryFake()
        )
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

}
