//
//  UtilityUnitTests.swift
//  UtilityUnitTests
//
//  Created by Jaewon Yun on 2023/09/07.
//

import Utility
import XCTest

final class UtilityUnitTests: XCTestCase {

    func testcastOrFatalErrorSuccess() {
        let optionalValue: Int? = 1

        let result: Int = castOrFatalError(optionalValue)

        XCTAssertEqual(result, 1)
    }

}
