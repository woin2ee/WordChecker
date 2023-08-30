//
//  XCUIApplication+launchEnvironment.swift
//  WordCheckerUITests
//
//  Created by Jaewon Yun on 2023/08/27.
//

import Foundation
import WordChecker
import XCTest

extension XCUIApplication {

    func setLaunchArguments(_ arguments: [LaunchArguments]) {
        self.launchArguments = arguments.map(\.rawValue)
    }

}
