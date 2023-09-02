//
//  XCUIElement+clearAndEnterText.swift
//  WordCheckerUITests
//
//  Created by Jaewon Yun on 2023/09/02.
//

import Foundation
import XCTest

extension XCUIElement {

    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }

        self.tap()

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)

        self.typeText(deleteString)
        self.typeText(text)
    }

}
