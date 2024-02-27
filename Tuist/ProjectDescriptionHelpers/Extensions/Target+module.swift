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

extension Target {

    public static func module(
        name: String,
        platform: ProjectDescription.Platform = .iOS,
        product: ProjectDescription.Product = .framework,
        bundleId: String? = nil,
        deploymentTarget: ProjectDescription.DeploymentTarget = DEPLOYMENT_TARGET,
        infoPlist: InfoPlist? = .default,
        resourceOptions: [ResourceOption] = [],
        entitlements: ProjectDescription.Path? = nil,
        scripts: [ProjectDescription.TargetScript] = [],
        dependencies: [ProjectDescription.TargetDependency] = [],
        settings: ProjectDescription.Settings? = nil,
        coreDataModels: [ProjectDescription.CoreDataModel] = [],
        environment: [String: String] = [:],
        launchArguments: [ProjectDescription.LaunchArgument] = [],
        additionalFiles: [ProjectDescription.FileElement] = [],
        hasTests: Bool = false,
        additionalTestDependencies: [ProjectDescription.TargetDependency] = [],
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

        let bundleID = if bundleId != nil {
            bundleId!
        } else {
            "\(BASIC_BUNDLE_ID).\(name.replacing("_", with: "."))"
        }

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
        let resources: ResourceFileElements = .init(resources: resourceFileElements)

        let scheme: Scheme = {
            if hasTests {
                let testPlanName: String = if let namePrefix = namePrefix, let nameSuffix = nameSuffix {
                    "TestPlans/\(namePrefix)/\(nameSuffix).xctestplan"
                } else {
                    "TestPlans/\(name).xctestplan"
                }

                return Scheme(
                    name: name,
                    buildAction: .buildAction(targets: ["\(name)"]),
                    testAction: .testPlans([.relativeToRoot(testPlanName)])
                )
            } else {
                return Scheme(
                    name: name,
                    buildAction: .buildAction(targets: ["\(name)"])
                )
            }
        }()
        schemes.append(scheme)

        let sources: SourceFilesList = if let namePrefix = namePrefix, let nameSuffix = nameSuffix {
            "Sources/\(namePrefix)/\(nameSuffix)/**"
        } else {
            "Sources/\(name)/**"
        }

        let frameworkTarget: Target = .init(
            name: name,
            platform: platform,
            product: product,
            productName: nil,
            bundleId: bundleID,
            deploymentTarget: deploymentTarget,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            copyFiles: nil,
            headers: nil,
            entitlements: entitlements,
            scripts: scripts,
            dependencies: dependencies,
            settings: settings,
            coreDataModels: coreDataModels,
            environment: environment,
            launchArguments: launchArguments,
            additionalFiles: additionalFiles,
            buildRules: []
        )

        if hasTests {
            let testsTargetName = "\(name)Tests"
            let testsSources: SourceFilesList = if let namePrefix = namePrefix, let nameSuffix = nameSuffix {
                "Tests/\(namePrefix)Tests/\(nameSuffix)Tests/**"
            } else {
                "Tests/\(testsTargetName)/**"
            }
            let testBundleID = "\(BASIC_BUNDLE_ID).\(testsTargetName.replacing("_", with: "."))"

            let testsTarget: Target = .init(
                name: testsTargetName,
                platform: platform,
                product: .unitTests,
                productName: nil,
                bundleId: testBundleID,
                deploymentTarget: deploymentTarget,
                infoPlist: .default,
                sources: testsSources,
                resources: resources,
                copyFiles: nil,
                headers: nil,
                entitlements: entitlements,
                scripts: scripts,
                dependencies: [.target(name: name)] + additionalTestDependencies,
                settings: settings,
                coreDataModels: coreDataModels,
                environment: environment,
                launchArguments: launchArguments,
                additionalFiles: additionalFiles,
                buildRules: []
            )

            return [frameworkTarget, testsTarget]
        } else {
            return [frameworkTarget]
        }
    }

}
