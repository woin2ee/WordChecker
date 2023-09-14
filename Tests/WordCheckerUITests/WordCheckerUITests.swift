//
//  WordCheckerUITests.swift
//  WordCheckerUITests
//
//  Created by Jaewon Yun on 2023/08/23.
//

import iOSCore
import LaunchArguments
import Localization
import XCTest

final class WordCheckerUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = .init()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testWordCheckUseCase() {
        // App Launch
        app.setLaunchArguments([.useInMemoryDatabase])
        app.launch()

        // Save word
        app.staticTexts[WCString.noWords].assertExistence()
        runAddWord(text: "TestWord")
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

        // Append word
        runAddWord(text: "Append1")
        runAddWord(text: "Append2")

        // Check next word
        app.buttons[AccessibilityIdentifier.WordChecking.nextButton].tap()
        app.staticTexts["Append1"].assertExistence()
        app.buttons[AccessibilityIdentifier.WordChecking.nextButton].tap()
        app.staticTexts["Append2"].assertExistence()

        // Check previous word
        app.buttons[AccessibilityIdentifier.WordChecking.previousButton].tap()
        app.staticTexts["Append1"].assertExistence()
        app.buttons[AccessibilityIdentifier.WordChecking.previousButton].tap()
        app.staticTexts["EditedWord"].assertExistence()

        // Delete
        var currentWord: String = app.descendants(matching: .any)[AccessibilityIdentifier.WordChecking.wordLabel].label
        app.tabBars.buttons[WCString.list].tap()
        app.staticTexts["EditedWord"].swipeLeft()
        app.buttons[WCString.delete].tap()
        XCTAssertEqual(app.tables.cells.count, 2)
        app.tabBars.buttons[WCString.memorization].tap()
        var newCurrentWord = app.descendants(matching: .any)[AccessibilityIdentifier.WordChecking.wordLabel].label
        XCTAssertNotEqual(currentWord, newCurrentWord)

        // Shuffle
        currentWord = app.descendants(matching: .any)[AccessibilityIdentifier.WordChecking.wordLabel].label
        app.navigationBars.buttons[AccessibilityIdentifier.WordChecking.moreButton].tap()
        app.collectionViews.buttons[WCString.shuffleOrder].tap()
        newCurrentWord = app.descendants(matching: .any)[AccessibilityIdentifier.WordChecking.wordLabel].label
        XCTAssertNotEqual(currentWord, newCurrentWord)

        let image = app.screenshot().image
    }

    func testWordListUseCase() {
        // App Launch
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

    func testNoWordMessage() {
        app.setLaunchArguments([.useInMemoryDatabase])
        app.launch()

        moveListTap()

        app.staticTexts[WCString.there_are_no_words].assertExistence()
    }

}

// MARK: - Helpers

extension WordCheckerUITests {

    func runAddWord(text: String) {
        app.navigationBars.buttons[AccessibilityIdentifier.WordChecking.addWordButton].tap()
        let addAlert = app.alerts[WCString.addWord]
        addAlert.textFields.firstMatch.typeText(text)
        addAlert.buttons[WCString.add].tap()
    }

    func moveListTap() {
        app.tabBars.buttons[WCString.list].tap()
    }

    func moveCheckingTap() {
        app.tabBars.buttons[WCString.memorization].tap()
    }

}
