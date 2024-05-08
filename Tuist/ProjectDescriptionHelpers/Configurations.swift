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

public let MINIMUM_IOS_VERSION = "17.0"

public let MINIMUM_MACOS_VERSION = "14.0.0"

public let ALL_DEPLOYMENT_TARGETS: DeploymentTargets = .multiplatform(
    iOS: MINIMUM_IOS_VERSION,
    macOS: MINIMUM_MACOS_VERSION
)

public let ALL_DESTINATIONS: Destinations = [.iPhone, .mac]
