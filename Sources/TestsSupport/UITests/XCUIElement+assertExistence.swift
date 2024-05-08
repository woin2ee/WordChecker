//
//  XCUIElement+assertExistence.swift
//  WordCheckerUITests
//
//  Created by Jaewon Yun on 2023/08/28.
//

import Foundation
import XCTest

extension XCUIElement {

    /// Asserts exist self.
    /// - Parameter timeout: The default value is 3.
    public func assertExistence(timeout: TimeInterval = 3.0) {
        XCTAssert(self.waitForExistence(timeout: timeout))
    }

}
