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

    func testCRUDWord() {
        // App Launch
        let app = XCUIApplication()
        app.setLaunchArguments([.useInMemoryDatabase])
        app.launch()

        // Create
        app.staticTexts[WCString.noWords].assertExistence()

        app.navigationBars.buttons[AccessibilityIdentifier.WordChecking.moreButton].tap()
        app.collectionViews.buttons[WCString.addWord].tap()

        let addAlert = app.alerts[WCString.addWord]
        addAlert.textFields.firstMatch.typeText("TestWord")
        addAlert.buttons[WCString.add].tap()

        app.staticTexts["TestWord"].assertExistence()

        // Read
        app.buttons[AccessibilityIdentifier.WordChecking.listButton].tap()

        app.staticTexts["TestWord"].assertExistence()

        // Update
        app.staticTexts["TestWord"].swipeLeft()
        app.buttons[WCString.edit].tap()

        let editAlert = app.alerts[WCString.editWord]
        editAlert.textFields.firstMatch.clearAndEnterText(text: "EditedWord")
        editAlert.buttons[WCString.edit].tap()

        app.staticTexts["EditedWord"].assertExistence()

        // Delete
        app.staticTexts["EditedWord"].swipeLeft()
        app.buttons[WCString.delete].tap()

        XCTAssertEqual(app.tableRows.count, 0)

        // Final Assertion
        app.navigationBars.backButton.tap()

        app.staticTexts[WCString.noWords].assertExistence()

        let image = app.screenshot().image
    }

}
