//
//  WCUserDefaultsTests.swift
//  DomainUnitTests
//
//  Created by Jaewon Yun on 2023/09/19.
//  Copyright © 2023 woin2ee. All rights reserved.
//

@testable import UserDefaultsPlatform
import XCTest

final class WCUserDefaultsTests: XCTestCase {

    var sut: WCUserDefaults!

    override func setUpWithError() throws {
        try super.setUpWithError()

        let userDefaults: UserDefaults = .init(suiteName: #file)!

        sut = .init(_userDefaults: userDefaults)

        clearWCUserDefaults(sut)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
    }

    func testSetAndGetCodable() {
        // Given
        let testCodable: TestCodable = .init(name: "Test", data: .init(repeating: 8, count: 8))

        let setResult = sut.setCodable(testCodable, forKey: .test)

        // When
        let getResult = sut.object(TestCodable.self, forKey: .test)

        // Then
        XCTAssertNoThrow(try setResult.get())
        XCTAssertNoThrow(try getResult.get())
    }

    func testThrowErrorWhenGetCodableForNotSavedKey() {
        // When
        let getResult = sut.object(TestCodable.self, forKey: .test)

        // Then
        XCTAssertThrowsError(try getResult.get())
    }

    func testThrowWhenFailedEncode() {
        // Given
        let testCodable: TestCodable = .init(name: "Test", data: .init(), amount: .infinity)

        // When
        let result = sut.setCodable(testCodable, forKey: .test)

        // Then
        XCTAssertThrowsError(try result.get())
    }

}

// MARK: - Helpers

extension WCUserDefaultsTests {

    struct TestCodable: Codable {

        let name: String

        let data: Data

        var amount: Double = 0

    }

}
