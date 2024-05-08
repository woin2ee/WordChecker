//
//  AppStoreScreenshotsGenerator.swift
//  WordCheckerUITests
//
//  Created by Jaewon Yun on 5/8/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import TestsSupport
import XCTest

final class AppStoreScreenshotsGenerator: XCTestCase {

    var app: XCUIApplication!
    
    @MainActor
    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
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
        
        snapshot("01HomeScreen")
    }
    
    @MainActor
    func test_iPad() throws {
        guard UIDevice.current.userInterfaceIdiom == .pad else {
            return
        }
        
        XCUIDevice.shared.orientation = .landscapeLeft
        
        app.launch()
        
        snapshot("01HomeScreen")
    }
}
