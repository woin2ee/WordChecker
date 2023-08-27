//
//  WordCheckerUITests.swift
//  WordCheckerUITests
//
//  Created by Jaewon Yun on 2023/08/23.
//

@testable import WordChecker
import XCTest

final class WordCheckerUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func test() {
         
        let app = XCUIApplication()
        app.setLaunchArguments([.useInMemoryDB])
        app.launch()
        
        app.buttons[WCScene.WordChecking.AccessibilityIdentifier.listButton].tap()
        
//        let button = app.navigationBars["단어 목록"].buttons["뒤로"]
//        button.tap()
//        app.navigationBars.buttons["추가"].tap()
//        app.alerts["단어 추가"].scrollViews.otherElements.buttons["추가"].tap()
//        app.buttons["다음"].tap()
//        staticText.tap()
//        button.tap()
//        app/*@START_MENU_TOKEN@*/.staticTexts["순서 섞기"]/*[[".buttons[\"순서 섞기\"].staticTexts[\"순서 섞기\"]",".staticTexts[\"순서 섞기\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.buttons["번역"].tap()
//        app.navigationBars["UIView"].buttons["뒤로"].tap()
        
    }
    
}
