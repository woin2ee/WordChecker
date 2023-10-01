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

    case `default`

    case additional(ProjectDescription.ResourceFileElement)

}

extension Target {

    /// Parameters 에 따라 Target 을 만들고 Unit Tests Target 을 추가하거나 Scheme 을 추가하는 등의 작업을 수행합니다.
    ///
    /// 특정 Bundle ID 를 지정하지 않을 경우 모듈의 Bundle ID 는 Configurations.swift 파일에 정의된 `BASIC_BUNDLE_ID` 을 사용하여 `$(BASIC_BUNDLE_ID).$(name)` 으로 지정됩니다.
    /// 테스트 타겟의 Bundle ID 는 `$(BASIC_BUNDLE_ID).$(name)UnitTests` 으로 지정됩니다.
    ///
    /// 모듈의 Sources 패스는 `Source/$(name)`이고 Tests 패스는 `Tests/$(name)UnitTests` 입니다.
    public static func module(
        name: String,
        platform: ProjectDescription.Platform,
        product: ProjectDescription.Product,
        bundleId: String? = nil,
        deploymentTarget: ProjectDescription.DeploymentTarget,
        resourceOptions: [ResourceOption] = [],
//        resources: ProjectDescription.ResourceFileElements? = nil,
        entitlements: ProjectDescription.Path? = nil,
        scripts: [ProjectDescription.TargetScript] = [],
        dependencies: [ProjectDescription.TargetDependency] = [],
        settings: ProjectDescription.Settings? = nil,
        coreDataModels: [ProjectDescription.CoreDataModel] = [],
        environment: [String: String] = [:],
        launchArguments: [ProjectDescription.LaunchArgument] = [],
        additionalFiles: [ProjectDescription.FileElement] = [],
        hasUnitTests: Bool = false,
        additionalTestDependencies: [ProjectDescription.TargetDependency] = [],
        appendSchemeTo scheme: inout [Scheme]
    ) -> [Target] {
        let bundleId = bundleId ?? "\(BASIC_BUNDLE_ID).\(name)"

        let resourceFileElements = resourceOptions
            .reduce(into: [ResourceFileElement](), { partialResult, option in
                switch option {
                case .common:
                    partialResult.append("Resources/Common/**")
                case .default:
                    partialResult.append("Resources/\(name)/**")
                case .additional(let resourceFileElement):
                    partialResult.append(resourceFileElement)
                }
            })
        let resources: ResourceFileElements = .init(resources: resourceFileElements)

        if hasUnitTests {
            let moduleScheme: Scheme = .init(
                name: name,
                buildAction: .buildAction(targets: ["\(name)"]),
                testAction: .testPlans([.relativeToRoot("TestPlans/\(name).xctestplan")])
            )
            scheme.append(moduleScheme)
        } else {
            let moduleScheme: Scheme = .init(
                name: name,
                buildAction: .buildAction(targets: ["\(name)"])
            )
            scheme.append(moduleScheme)
        }

        let frameworkTarget: Target = .init(
            name: name,
            platform: platform,
            product: product,
            productName: nil,
            bundleId: bundleId,
            deploymentTarget: deploymentTarget,
            infoPlist: .default,
            sources: "Sources/\(name)/**",
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

        if hasUnitTests {
            let unitTestsTarget: Target = .init(
                name: "\(name)UnitTests",
                platform: platform,
                product: .unitTests,
                productName: nil,
                bundleId: "\(BASIC_BUNDLE_ID).\(name)UnitTests",
                deploymentTarget: deploymentTarget,
                infoPlist: .default,
                sources: "Tests/\(name)UnitTests/**",
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

            return [frameworkTarget, unitTestsTarget]
        } else {
            return [frameworkTarget]
        }
    }

}
