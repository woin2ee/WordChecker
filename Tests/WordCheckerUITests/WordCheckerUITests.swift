//
//  WordCheckerUITests.swift
//  WordCheckerUITests
//
//  Created by Jaewon Yun on 2023/08/23.
//

@testable import IOSScene_UserSettings
@testable import IOSScene_WordChecking
@testable import IOSScene_WordList
@testable import IOSScene_WordDetail
@testable import IOSScene_WordAddition
@testable import IOSSupport
@testable import IPhoneDriver
import XCTest

typealias WordCheckingString            = IOSScene_WordChecking.LocalizedString
typealias WordCheckingAccessibilityID   = IOSScene_WordChecking.AccessibilityIdentifier
typealias WordListString                = IOSScene_WordList.LocalizedString
typealias WordListAccessibilityID       = IOSScene_WordList.AccessibilityIdentifier
typealias WordDetailString              = IOSScene_WordDetail.LocalizedString
typealias WordDetailAccessibilityID     = IOSScene_WordDetail.AccessibilityIdentifier
typealias UserSettingsString            = IOSScene_UserSettings.LocalizedString
typealias IOSSupportString              = IOSSupport.LocalizedString
typealias IPhoneDriverString            = IPhoneDriver.LocalizedString

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
        app.staticTexts[WordCheckingString.noWords].assertExistence()
        runAddWord(text: "TestWord")
        app.staticTexts["TestWord"].assertExistence()

        // Show list
        app.tabBars.buttons[IPhoneDriverString.tabBarItem2].tap()
        app.staticTexts["TestWord"].assertExistence()

        // Edit word
        app.staticTexts["TestWord"].swipeLeft()
        app.buttons[WordListString.edit].tap()
        let editAlert = app.alerts[WordListString.editWord]
        editAlert.textFields.firstMatch.clearAndEnterText(text: "EditedWord")
        editAlert.buttons[WordListString.edit].tap()
        app.staticTexts["EditedWord"].assertExistence()
        app.tabBars.buttons[IPhoneDriverString.tabBarItem1].tap()
        app.staticTexts["EditedWord"].assertExistence()

        // Append word
        runAddWord(text: "Append1")
        runAddWord(text: "Append2")

        // Check next word
        app.buttons[WordCheckingAccessibilityID.nextButton].tap()
        app.staticTexts["Append1"].assertExistence()
        app.buttons[WordCheckingAccessibilityID.nextButton].tap()
        app.staticTexts["Append2"].assertExistence()

        // Check previous word
        app.buttons[WordCheckingAccessibilityID.previousButton].tap()
        app.staticTexts["Append1"].assertExistence()
        app.buttons[WordCheckingAccessibilityID.previousButton].tap()
        app.staticTexts["EditedWord"].assertExistence()

        // Delete
        var currentWord: String = app.descendants(matching: .any)[WordCheckingAccessibilityID.wordLabel].label
        moveListTap()
        app.staticTexts[currentWord].swipeLeft()
        app.buttons[WordListString.delete].tap()
        XCTAssertEqual(app.tables.cells.count, 2)
        moveCheckingTap()
        var newCurrentWord = app.descendants(matching: .any)[WordCheckingAccessibilityID.wordLabel].label
        XCTAssertNotEqual(currentWord, newCurrentWord)

        // Shuffle
        currentWord = app.descendants(matching: .any)[WordCheckingAccessibilityID.wordLabel].label
        app.navigationBars.buttons[WordCheckingAccessibilityID.moreButton].tap()
        app.collectionViews.buttons[WordCheckingString.shuffleOrder].tap()
        newCurrentWord = app.descendants(matching: .any)[WordCheckingAccessibilityID.wordLabel].label
        XCTAssertNotEqual(currentWord, newCurrentWord)
    }

    func testWordListUseCase() {
        // App Launch
        app.setLaunchArguments([.useInMemoryDatabase])
        app.launch()

        // Prepare
        runAddWord(text: "Test1")
        runAddWord(text: "Test2")
        runAddWord(text: "Test3")

        let currentWord: String = app.descendants(matching: .any)[WordCheckingAccessibilityID.wordLabel].label

        app.tabBars.buttons[IPhoneDriverString.tabBarItem2].tap()

        // Search word
        app.searchFields.firstMatch.tap()
        app.searchFields.firstMatch.typeText(currentWord)
        app.staticTexts[currentWord].assertExistence()

        // Edit details
        app.tables.element(boundBy: 1).cells.element(boundBy: 0).tap()
        let detailTextField = app.textFields[WordDetailAccessibilityID.wordTextField]
        let detailMemorizingButton = app.buttons[WordDetailAccessibilityID.memorizingButton]
        let detailMemorizedButton = app.buttons[WordDetailAccessibilityID.memorizedButton]
        XCTAssertEqual(detailTextField.value as? String, currentWord)
        XCTAssertEqual(detailMemorizingButton.isSelected, true)
        detailTextField.tap()
        detailTextField.typeText("#")
        detailMemorizedButton.tap()
        XCTAssertEqual(detailMemorizedButton.isSelected, true)
        app.navigationBars.buttons[WordDetailString.done].tap()
        app.tables.element(boundBy: 1).cells.staticTexts["\(currentWord)#"].assertExistence()

        // Check memorization state
        app.tabBars.buttons[IPhoneDriverString.tabBarItem1].tap()
        let newWord: String = app.descendants(matching: .any)[WordCheckingAccessibilityID.wordLabel].label
        XCTAssertNotEqual("\(currentWord)#", newWord)

        // Change state to memorizing
        do {
            app.navigationBars.buttons[WordCheckingAccessibilityID.moreButton].tap()
            app.collectionViews.buttons[WordCheckingString.memorized].tap()
            app.navigationBars.buttons[WordCheckingAccessibilityID.moreButton].tap()
            app.collectionViews.buttons[WordCheckingString.memorized].tap()

            moveListTap()

            app.tables.element(boundBy: 1).cells.element(boundBy: 0).tap()
            app.buttons[WordDetailAccessibilityID.memorizingButton].tap()
            app.navigationBars.buttons[WordDetailString.done].tap()

            moveCheckingTap()

            let currentWord: String = app.descendants(matching: .any)[WordCheckingAccessibilityID.wordLabel].label
            XCTAssertNotEqual(currentWord, WordCheckingString.noWords)
        }
    }

    func testNoWordMessage() {
        app.setLaunchArguments([.useInMemoryDatabase])
        app.launch()

        moveListTap()

        app.staticTexts[WordListString.there_are_no_words].assertExistence()
    }

    func testChangeTranslationLanguageSettings() {
        app.setLaunchArguments([.initUserDefaults])
        app.launch()

        moveSettingsTap()

        app.tables.element.staticTexts[UserSettingsString.source_language].tap()
        app.tables.element.staticTexts[IOSSupportString.russian].tap()
        app.navigationBars.backButton.tap()
        app.tables.element.staticTexts[IOSSupportString.russian].assertExistence()

        app.tables.element.staticTexts[UserSettingsString.translation_language].tap()
        app.tables.element.staticTexts[IOSSupportString.italian].tap()
        app.navigationBars.backButton.tap()
        app.tables.element.staticTexts[IOSSupportString.italian].assertExistence()
    }

}

// MARK: - Helpers

extension WordCheckerUITests {

    func runAddWord(text: String) {
        app.navigationBars.buttons[WordCheckingAccessibilityID.addWordButton].tap()
        let addAlert = app.alerts[WordCheckingString.quick_add_word]
        addAlert.textFields.firstMatch.typeText(text)
        addAlert.buttons[WordCheckingString.add].tap() // 텍스트로 판단
    }

    func moveListTap() {
        app.tabBars.buttons[IPhoneDriverString.tabBarItem2].tap()
    }

    func moveCheckingTap() {
        app.tabBars.buttons[IPhoneDriverString.tabBarItem1].tap()
    }

    func moveSettingsTap() {
        app.tabBars.buttons[IPhoneDriverString.tabBarItem3].tap()
    }

}
