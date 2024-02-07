//
//  XCUIApplication+launchEnvironment.swift
//  WordCheckerUITests
//
//  Created by Jaewon Yun on 2023/08/27.
//

import Foundation
import Utility
import XCTest

extension XCUIApplication {

    func setLaunchArguments(_ arguments: [LaunchArgument.Arguments]) {
        self.launchArguments = arguments.map(\.rawValue)
    }

}
