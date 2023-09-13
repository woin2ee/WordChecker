//
//  Target+target.swift
//  ProjectDescriptionHelpers
//
//  Created by Jaewon Yun on 2023/09/12.
//

import Foundation
import ProjectDescription

extension Target {
    
    // 주어진 name 으로 번들아이디, Sources 디렉토리, Tests 디렉토리를 세팅한 Target 을 반환합니다.
    public static func target(
        name: String,
        platform: ProjectDescription.Platform,
        product: ProjectDescription.Product,
        bundleId: String? = nil,
        deploymentTarget: ProjectDescription.DeploymentTarget,
        infoPlist: ProjectDescription.InfoPlist? = .default,
        resources: ProjectDescription.ResourceFileElements? = nil,
        copyFiles: [ProjectDescription.CopyFilesAction]? = nil,
        headers: ProjectDescription.Headers? = nil,
        entitlements: ProjectDescription.Path? = nil,
        scripts: [ProjectDescription.TargetScript] = [],
        dependencies: [ProjectDescription.TargetDependency] = [],
        settings: ProjectDescription.Settings? = nil,
        coreDataModels: [ProjectDescription.CoreDataModel] = [],
        environment: [String : String] = [:],
        launchArguments: [ProjectDescription.LaunchArgument] = [],
        additionalFiles: [ProjectDescription.FileElement] = [],
        buildRules: [ProjectDescription.BuildRule] = [],
        hasUnitTests: Bool = false,
        additionalTestDependencies: [ProjectDescription.TargetDependency] = []
    ) -> [Target] {
        let bundleId = bundleId ?? "\(BASIC_BUNDLE_ID).\(name)"
        
        let frameworkTarget: Target = .init(
            name: name,
            platform: platform,
            product: product,
            productName: nil,
            bundleId: bundleId,
            deploymentTarget: deploymentTarget,
            infoPlist: infoPlist,
            sources: "Sources/\(name)/**",
            resources: resources,
            copyFiles: copyFiles,
            headers: headers,
            entitlements: entitlements,
            scripts: scripts,
            dependencies: dependencies,
            settings: settings,
            coreDataModels: coreDataModels,
            environment: environment,
            launchArguments: launchArguments,
            additionalFiles: additionalFiles,
            buildRules: buildRules
        )
        
        if hasUnitTests {
            let unitTestsTarget: Target = .init(
                name: "\(name)UnitTests",
                platform: platform,
                product: .unitTests,
                productName: nil,
                bundleId: "\(BASIC_BUNDLE_ID).\(name)UnitTests",
                deploymentTarget: deploymentTarget,
                infoPlist: infoPlist,
                sources: "Tests/\(name)UnitTests/**",
                resources: resources,
                copyFiles: copyFiles,
                headers: headers,
                entitlements: entitlements,
                scripts: scripts,
                dependencies: [.target(name: name)] + additionalTestDependencies,
                settings: settings,
                coreDataModels: coreDataModels,
                environment: environment,
                launchArguments: launchArguments,
                additionalFiles: additionalFiles,
                buildRules: buildRules
            )
            
            return [frameworkTarget, unitTestsTarget]
        } else {
            return [frameworkTarget]
        }
    }
    
}
