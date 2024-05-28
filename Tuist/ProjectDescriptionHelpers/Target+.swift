//
//  Target+target.swift
//  ProjectDescriptionHelpers
//
//  Created by Jaewon Yun on 2023/09/12.
//

import Foundation
import ProjectDescription

public enum ResourceOption {

    case common

    case own

    case additional(ProjectDescription.ResourceFileElement)

}

fileprivate func _module(
    name: String,
    destinations: Destinations,
    product: Product,
    bundleID: String? = nil,
    deploymentTargets: DeploymentTargets? = nil, // 동적으로 destinations 에 등록된 것만 적용되는가? -> 되면 default value 로 해결 가능
    infoPlist: InfoPlist? = .default,
    entitlements: Entitlements? = nil,
    scripts: [TargetScript] = [],
    dependencies: [TargetDependency] = [],
    settings: Settings? = nil,
    launchArguments: [LaunchArgument] = [],
    additionalFiles: [FileElement] = [],
    resourceOptions: [ResourceOption] = [],
    hasTests: Bool = false,
    additionalTestDependencies: [ProjectDescription.TargetDependency] = [],
    withTesting: Bool = false,
    additionalTestingDependencies: [ProjectDescription.TargetDependency] = [],
    appendSchemeTo schemes: inout [Scheme]
) -> [Target] {
    var namePrefix: String?
    var nameSuffix: String?

    // Example
    // - name: IOSScene_WordChecking
    // - nameComponents[0]: IOSScene
    // - nameComponents[1]: WordChecking
    let nameComponents = name.components(separatedBy: "_")
    precondition(nameComponents.count <= 2)

    if nameComponents.count == 2 {
        namePrefix = nameComponents[0]
        nameSuffix = nameComponents[1]
    }
    
    let bundleID = bundleID ?? "\(BASIC_BUNDLE_ID).\(name.replacing("_", with: "."))"

    let resourceFileElements = resourceOptions
        .reduce(into: [ResourceFileElement](), { partialResult, option in
            switch option {
            case .common:
                partialResult.append("Resources/Common/**")
            case .own:
                let path: ResourceFileElement = if let namePrefix = namePrefix, let nameSuffix = nameSuffix {
                    "Resources/\(namePrefix)/\(nameSuffix)/**"
                } else {
                    "Resources/\(name)/**"
                }
                partialResult.append(path)
            case .additional(let resourceFileElement):
                partialResult.append(resourceFileElement)
            }
        })
    let resources: ResourceFileElements = .resources(resourceFileElements)
    
    var scheme = Scheme.scheme(
        name: name,
        shared: true,
        buildAction: .buildAction(targets: ["\(name)"])
    )
    if hasTests {
        let testPlanName: String = if let namePrefix = namePrefix, let nameSuffix = nameSuffix {
            "TestPlans/\(namePrefix)/\(nameSuffix).xctestplan"
        } else {
            "TestPlans/\(name).xctestplan"
        }
        scheme.testAction = .testPlans([.relativeToRoot(testPlanName)])
    }
    if withTesting {
        scheme.buildAction?.targets.append("\(name)Testing")
    }
    schemes.append(scheme)
    
    let sources: SourceFilesList = if let namePrefix = namePrefix, let nameSuffix = nameSuffix {
        "Sources/\(namePrefix)/\(nameSuffix)/**"
    } else {
        "Sources/\(name)/**"
    }

    let frameworkTarget: Target = .target(
        name: name,
        destinations: destinations,
        product: product,
        productName: nil,
        bundleId: bundleID,
        deploymentTargets: deploymentTargets,
        infoPlist: infoPlist,
        sources: sources,
        resources: resources,
        copyFiles: nil,
        headers: nil,
        entitlements: entitlements,
        scripts: scripts,
        dependencies: dependencies,
        settings: settings,
        coreDataModels: [],
        environmentVariables: [:],
        launchArguments: launchArguments,
        additionalFiles: additionalFiles,
        buildRules: [],
        mergedBinaryType: .disabled,
        mergeable: false
    )
    
    var targets: [Target] = [frameworkTarget]
    
    if hasTests {
        let testsTargetName = "\(name)Tests"
        let testsSources: SourceFilesList = if let namePrefix = namePrefix, let nameSuffix = nameSuffix {
            "Tests/\(namePrefix)Tests/\(nameSuffix)Tests/**"
        } else {
            "Tests/\(testsTargetName)/**"
        }
        let testBundleID = "\(BASIC_BUNDLE_ID).\(testsTargetName.replacing("_", with: "."))"

        let testsTarget: Target = .target(
            name: testsTargetName,
            destinations: destinations,
            product: .unitTests,
            productName: nil,
            bundleId: testBundleID,
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: testsSources,
            resources: resources,
            copyFiles: nil,
            headers: nil,
            entitlements: entitlements,
            scripts: [],
            dependencies: [.target(name: name)] + additionalTestDependencies,
            settings: nil,
            coreDataModels: [],
            environmentVariables: [:],
            launchArguments: [],
            additionalFiles: [],
            buildRules: [],
            mergedBinaryType: .disabled,
            mergeable: false
        )
        
        targets.append(testsTarget)
    }
    
    if withTesting {
        let testingTargetName = "\(name)Testing"
        let testingSources: SourceFilesList = if let namePrefix = namePrefix, let nameSuffix = nameSuffix {
            "Sources/\(namePrefix)/\(nameSuffix)Testing/**"
        } else {
            "Sources/\(testingTargetName)/**"
        }
        let testingBundleID = "\(BASIC_BUNDLE_ID).\(testingTargetName.replacing("_", with: "."))"
        
        let testingTarget: Target = .target(
            name: testingTargetName,
            destinations: destinations,
            product: product,
            productName: nil,
            bundleId: testingBundleID,
            deploymentTargets: deploymentTargets,
            infoPlist: infoPlist,
            sources: testingSources,
            resources: resources,
            copyFiles: nil,
            headers: nil,
            entitlements: entitlements,
            scripts: scripts,
            dependencies: [.target(name: name)] + additionalTestingDependencies,
            settings: settings,
            coreDataModels: [],
            environmentVariables: [:],
            launchArguments: launchArguments,
            additionalFiles: additionalFiles,
            buildRules: [],
            mergedBinaryType: .disabled,
            mergeable: false
        )
        
        targets.append(testingTarget)
    }
    
    return targets
}

extension Target {
    
    public static func makeTargets(
        name: String,
        destinations: Destinations,
        product: Product,
        bundleID: String? = nil,
        deploymentTargets: DeploymentTargets? = nil,
        infoPlist: InfoPlist? = .default,
        entitlements: Entitlements? = nil,
        scripts: [TargetScript] = [],
        dependencies: [TargetDependency] = [],
        settings: Settings? = nil,
        launchArguments: [LaunchArgument] = [],
        additionalFiles: [FileElement] = [],
        resourceOptions: [ResourceOption] = [],
        hasTests: Bool = false,
        additionalTestDependencies: [ProjectDescription.TargetDependency] = [],
        appendSchemeTo schemes: inout [Scheme]
    ) -> [Target] {
        return _module(
            name: name,
            destinations: destinations,
            product: product,
            bundleID: bundleID,
            deploymentTargets: deploymentTargets,
            infoPlist: infoPlist,
            entitlements: entitlements,
            scripts: scripts,
            dependencies: dependencies,
            settings: settings,
            launchArguments: launchArguments,
            additionalFiles: additionalFiles,
            resourceOptions: resourceOptions,
            hasTests: hasTests,
            additionalTestDependencies: additionalTestDependencies,
            appendSchemeTo: &schemes
        )
    }
    
    public static func makeCommonFramework(
        name: String,
        scripts: [TargetScript] = [],
        dependencies: [TargetDependency] = [],
        settings: Settings? = nil,
        launchArguments: [LaunchArgument] = [],
        additionalFiles: [FileElement] = [],
        resourceOptions: [ResourceOption] = [],
        hasTests: Bool = false,
        additionalTestDependencies: [ProjectDescription.TargetDependency] = [],
        withTesting: Bool = false,
        additionalTestingDependencies: [ProjectDescription.TargetDependency] = [],
        appendSchemeTo schemes: inout [Scheme]
    ) -> [Target] {
        return _module(
            name: name,
            destinations: ALL_DESTINATIONS,
            product: .framework,
            bundleID: nil,
            deploymentTargets: ALL_DEPLOYMENT_TARGETS,
            infoPlist: .default,
            scripts: scripts,
            dependencies: dependencies,
            settings: settings,
            launchArguments: launchArguments,
            additionalFiles: additionalFiles,
            resourceOptions: resourceOptions,
            hasTests: hasTests,
            additionalTestDependencies: additionalTestDependencies,
            withTesting: withTesting,
            additionalTestingDependencies: additionalTestingDependencies,
            appendSchemeTo: &schemes
        )
    }
    
    public static func makeIOSFramework(
        name: String,
        scripts: [TargetScript] = [],
        dependencies: [TargetDependency] = [],
        settings: Settings? = nil,
        launchArguments: [LaunchArgument] = [],
        additionalFiles: [FileElement] = [],
        resourceOptions: [ResourceOption] = [],
        hasTests: Bool = false,
        additionalTestDependencies: [ProjectDescription.TargetDependency] = [],
        appendSchemeTo schemes: inout [Scheme]
    ) -> [Target] {
        return _module(
            name: name,
            destinations: .iOS,
            product: .framework,
            bundleID: nil,
            deploymentTargets: .iOS(MINIMUM_IOS_VERSION),
            infoPlist: .default,
            scripts: scripts,
            dependencies: dependencies,
            settings: settings,
            launchArguments: launchArguments,
            additionalFiles: additionalFiles,
            resourceOptions: resourceOptions,
            hasTests: hasTests,
            additionalTestDependencies: additionalTestDependencies,
            appendSchemeTo: &schemes
        )
    }

}
