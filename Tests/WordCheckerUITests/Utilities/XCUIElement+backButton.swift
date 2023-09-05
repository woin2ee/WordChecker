//
//  XCUIElement+backButton.swift
//  WordCheckerUITests
//
//  Created by Jaewon Yun on 2023/09/03.
//

import Foundation
import XCTest

extension XCUIElementTypeQueryProvider {

    var backButton: XCUIElement {
        return self.buttons.element(boundBy: 0)
    }

}
