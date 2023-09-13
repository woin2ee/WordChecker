//
//  DeploymentTarget+platform.swift
//  ProjectDescriptionHelpers
//
//  Created by Jaewon Yun on 2023/05/19.
//

import ProjectDescription

extension DeploymentTarget {
    
    /// 해당 `DeploymentTarget` 에 대한 `platform` 을 반환합니다.
    public var platform: Platform {
        switch self {
        case .iOS:
            return .iOS
        case .macOS:
            return .macOS
        case .watchOS:
            return .watchOS
        case .tvOS:
            return .tvOS
        case .visionOS:
            return .visionOS
        @unknown default:
            fatalError("Undefined platform. \(#file) \(#line)")
        }
    }
}
