//
//  Configurations.swift
//  ProjectDescriptionHelpers
//
//  Created by Jaewon Yun on 2023/09/12.
//

import Foundation
import ProjectDescription

// MARK: - Configurations

public let ORGANIZATION = "woin2ee"

public let PROJECT_NAME = "WordChecker"

public let BASIC_BUNDLE_ID = "com.\(ORGANIZATION).\(PROJECT_NAME)"

public let DEPLOYMENT_TARGET: DeploymentTarget = .iOS(targetVersion: "16.0", devices: [.iphone])

public let XCODE_VERSION: Version? = .init(14, 3, 1)
