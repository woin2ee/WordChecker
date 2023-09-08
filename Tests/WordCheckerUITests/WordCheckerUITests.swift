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

    func testWordCheckUseCase() {
        // App Launch
        let app = XCUIApplication()
        app.setLaunchArguments([.useInMemoryDatabase])
        app.launch()

        // Save word
        app.staticTexts[WCString.noWords].assertExistence()
        app.navigationBars.buttons[AccessibilityIdentifier.WordChecking.moreButton].tap()
        app.collectionViews.buttons[WCString.addWord].tap()
        let addAlert = app.alerts[WCString.addWord]
        addAlert.textFields.firstMatch.typeText("TestWord")
        addAlert.buttons[WCString.add].tap()
        app.staticTexts["TestWord"].assertExistence()

        // Show list
        app.tabBars.buttons[WCString.list].tap()
        app.staticTexts["TestWord"].assertExistence()

        // Edit word
        app.staticTexts["TestWord"].swipeLeft()
        app.buttons[WCString.edit].tap()
        let editAlert = app.alerts[WCString.editWord]
        editAlert.textFields.firstMatch.clearAndEnterText(text: "EditedWord")
        editAlert.buttons[WCString.edit].tap()
        app.staticTexts["EditedWord"].assertExistence()
        app.tabBars.buttons[WCString.memorization].tap()
        app.staticTexts["EditedWord"].assertExistence()
        app.tabBars.buttons[WCString.list].tap()

        // Delete
        app.staticTexts["EditedWord"].swipeLeft()
        app.buttons[WCString.delete].tap()
        XCTAssertEqual(app.tableRows.count, 0)

        // Final Assertion
        app.tabBars.buttons[WCString.memorization].tap()
        app.staticTexts[WCString.noWords].assertExistence()

        let image = app.screenshot().image
    }

    func testWordListUseCase() {
        // App Launch
        let app = XCUIApplication()
        app.setLaunchArguments([.sampledDatabase])
        app.launch()

        let currentWord: String = app.descendants(matching: .any)[AccessibilityIdentifier.WordChecking.wordLabel].label

        app.tabBars.buttons[WCString.list].tap()

        // Search word
        app.searchFields.firstMatch.tap()
        app.searchFields.firstMatch.typeText(currentWord)
        app.staticTexts[currentWord].assertExistence()

        // Edit details
        app.tables.element(boundBy: 1).cells.element(boundBy: 0).tap()
        let detailTextField = app.textFields[AccessibilityIdentifier.WordDetail.wordTextField]
        let detailMemorizationStateButton = app.buttons[AccessibilityIdentifier.WordDetail.memorizationStateButton]
        XCTAssertEqual(detailTextField.value as? String, currentWord)
        XCTAssertEqual(detailMemorizationStateButton.label, WCString.memorizing)
        detailTextField.tap()
        detailTextField.typeText("1")
        detailMemorizationStateButton.tap()
        app.buttons[WCString.memorized].tap()
        XCTAssertEqual(detailMemorizationStateButton.label, WCString.memorized)
        app.navigationBars.buttons[WCString.done].tap()
        app.tables.element(boundBy: 1).cells.staticTexts["\(currentWord)1"].assertExistence()

        // Check memorization state
        app.tabBars.buttons[WCString.memorization].tap()
        let newWord: String = app.descendants(matching: .any)[AccessibilityIdentifier.WordChecking.wordLabel].label
        XCTAssertNotEqual(currentWord, newWord)

        let image = app.screenshot().image
    }

}
