//
//  AppStoreScreenshotsGenerator.swift
//  WordCheckerUITests
//
//  Created by Jaewon Yun on 5/8/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

@testable import Domain_UserSettings
@testable import IPadDriver
@testable import IPhoneDriver
@testable import IOSScene_UserSettings
@testable import IOSScene_WordChecking

import TestsSupport
import XCTest

final class AppStoreScreenshotsGenerator: XCTestCase {

    var app: XCUIApplication!
    
    @MainActor
    override func setUpWithError() throws {
        continueAfterFailure = false

        SpringboardHelper.showKeyboardIfNeeded()
        
        app = XCUIApplication()
        app.setLaunchArguments([.sampledDatabase, .initUserDefaults])
        setupSnapshot(app)
    }

    override func tearDownWithError() throws {
        app = nil
    }

    @MainActor
    func test_iPhone() throws {
        guard UIDevice.current.userInterfaceIdiom == .phone else {
            return
        }
        
        XCUIDevice.shared.orientation = .portrait
        
        app.launch()
        
        (1...23).forEach { _ in
            app.buttons[IOSScene_WordChecking.AccessibilityIdentifier.nextButton].tap()
        }
        
        snapshot("01-home")
        
        app.navigationBars.buttons[IOSScene_WordChecking.AccessibilityIdentifier.addWordButton].tap()
        app.alerts.element.textFields.element.typeText("Recipient")
        
        snapshot("02-quick-add")
        
        app.alerts.element.buttons[IOSScene_WordChecking.LocalizedString.cancel].tap()
        
        app.tabBars.element.buttons[IPhoneDriver.LocalizedString.tabBarItem2].tap()
        app.searchFields.element.tap()
        app.searchFields.element.typeText("tion")
        
        snapshot("03-search-list")
        
        app.navigationBars.element.buttons[IOSScene_WordChecking.LocalizedString.cancel].tap()
        
        app.tabBars.element.buttons[IPhoneDriver.LocalizedString.tabBarItem3].tap()
        
        if Locale.current.language.languageCode?.identifier == TranslationLanguage.korean.bcp47tag.rawValue {
            app.tables.element.staticTexts[IOSScene_UserSettings.LocalizedString.source_language].tap()
            app.tables.element.staticTexts[TranslationLanguage.english.localizedString].tap()
            app.navigationBars.element.backButton.tap()
            app.tables.element.staticTexts[IOSScene_UserSettings.LocalizedString.translation_language].tap()
            app.tables.element.staticTexts[TranslationLanguage.korean.localizedString].tap()
            app.navigationBars.element.backButton.tap()
        } else {
            app.tables.element.staticTexts[IOSScene_UserSettings.LocalizedString.source_language].tap()
            app.tables.element.staticTexts[TranslationLanguage.spanish.localizedString].tap()
            app.navigationBars.element.backButton.tap()
            app.tables.element.staticTexts[IOSScene_UserSettings.LocalizedString.translation_language].tap()
            app.tables.element.staticTexts[TranslationLanguage.english.localizedString].tap()
            app.navigationBars.element.backButton.tap()
        }
        
        snapshot("04-language-settings")
    }
    
    @MainActor
    func test_iPad() throws {
        guard UIDevice.current.userInterfaceIdiom == .pad else {
            return
        }
        
        XCUIDevice.shared.orientation = .landscapeLeft
        
        app.launch()
        
        (1...23).forEach { _ in
            app.buttons[IOSScene_WordChecking.AccessibilityIdentifier.nextButton].tap()
        }
        
        snapshot("01-home")
        
        app.navigationBars.buttons[IOSScene_WordChecking.AccessibilityIdentifier.addWordButton].tap()
        app.alerts.element.textFields.element.typeText("Recipient")
        
        snapshot("02-quick-add")
        
        app.alerts.element.buttons[IOSScene_WordChecking.LocalizedString.cancel].tap()
        
        app.tables.staticTexts[IPadDriver.LocalizedString.wordListMenu].tap()
        app.searchFields.element.tap()
        app.searchFields.element.typeText("tion")
        
        snapshot("03-search-list")
        
        app.tables.staticTexts[IPadDriver.LocalizedString.userSettingsMenu].tap()
        
        if Locale.current.language.languageCode?.identifier == TranslationLanguage.korean.bcp47tag.rawValue {
            app.tables.element.staticTexts[IOSScene_UserSettings.LocalizedString.source_language].tap()
            app.tables.element.staticTexts[TranslationLanguage.english.localizedString].tap()
            app.navigationBars[IOSScene_UserSettings.LocalizedString.source_language].buttons.element.tap()
            app.tables.element.staticTexts[IOSScene_UserSettings.LocalizedString.translation_language].tap()
            app.tables.element.staticTexts[TranslationLanguage.korean.localizedString].tap()
            app.navigationBars[IOSScene_UserSettings.LocalizedString.translation_language].buttons.element.tap()
        } else {
            app.tables.element.staticTexts[IOSScene_UserSettings.LocalizedString.source_language].tap()
            app.tables.element.staticTexts[TranslationLanguage.spanish.localizedString].tap()
            app.navigationBars[IOSScene_UserSettings.LocalizedString.source_language].buttons.element.tap()
            app.tables.element.staticTexts[IOSScene_UserSettings.LocalizedString.translation_language].tap()
            app.tables.element.staticTexts[TranslationLanguage.english.localizedString].tap()
            app.navigationBars[IOSScene_UserSettings.LocalizedString.translation_language].buttons.element.tap()
        }
        
        snapshot("04-language-settings")
    }
}
