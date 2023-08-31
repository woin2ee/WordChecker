//
//  WordCheckerUITests.swift
//  WordCheckerUITests
//
//  Created by Jaewon Yun on 2023/08/23.
//

@testable import WordCheckerDev
import XCTest

final class WordCheckerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAddOneWord() {
        let app = XCUIApplication()
        app.setLaunchArguments([.useInMemoryDataBase])
        app.launch()

        app.staticTexts[WCString.noWords].assertExistence()

        app.navigationBars.buttons[AccessibilityIdentifier.WordChecking.addWordButton].tap()

        let addAlert = app.alerts[WCString.addWord]
        addAlert.assertExistence()
        addAlert.textFields.firstMatch.typeText("TestWord")
        addAlert.buttons[WCString.add].tap()

        app.staticTexts["TestWord"].assertExistence()

        let image = app.screenshot().image
    }

}
