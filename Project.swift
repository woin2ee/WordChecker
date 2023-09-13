import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

// Local plugin loaded
let localHelper = LocalHelper(name: "MyPlugin")

// MARK: - Targets

func targets() -> [Target] {
    let targets =
    [
        Target.target(
            name: "Domain",
            platform: .iOS,
            product: .framework,
            deploymentTarget: DEPLOYMENT_TARGET,
            dependencies: [
                .external(name: ExternalDependencyName.rxSwift),
                .target(name: "Utility")
            ],
            hasUnitTests: true,
            additionalTestDependencies: [
                .target(name: "State"),
                .target(name: "TestDoubles")
            ]
        )
        + Target.target(
            name: "RealmPlatform",
            platform: .iOS,
            product: .framework,
            deploymentTarget: DEPLOYMENT_TARGET,
            dependencies: [
                .package(product: ExternalDependencyName.realm),
                .package(product: ExternalDependencyName.realmSwift),
                .target(name: "Domain")
            ]
        )
        + Target.target(
            name: "Utility",
            platform: .iOS,
            product: .framework,
            deploymentTarget: DEPLOYMENT_TARGET,
            hasUnitTests: true
        )
        + Target.target(
            name: "State",
            platform: .iOS,
            product: .framework,
            deploymentTarget: DEPLOYMENT_TARGET,
            dependencies: [
                .target(name: "Domain"),
                .target(name: "Utility")
            ]
        )
        + Target.target(
            name: "LaunchArguments",
            platform: .iOS,
            product: .framework,
            deploymentTarget: DEPLOYMENT_TARGET
        )
        + Target.target(
            name: "TestDoubles",
            platform: .iOS,
            product: .framework,
            deploymentTarget: DEPLOYMENT_TARGET,
            dependencies: [
                .target(name: "Domain"),
                .target(name: "State"),
                .target(name: "Utility")
            ]
        )
        + Target.target(
            name: "iOSCore",
            platform: .iOS,
            product: .framework,
            deploymentTarget: DEPLOYMENT_TARGET,
            resources: [
                "Resources/Localization/**",
                "Resources/Common/**",
            ],
            dependencies: [
                .target(name: "Domain"),
                .target(name: "RealmPlatform"),
                .target(name: "State"),
                .target(name: "Utility"),
                .external(name: ExternalDependencyName.rxSwift),
                .external(name: ExternalDependencyName.rxCocoa),
                .external(name: ExternalDependencyName.rxUtilityDynamic),
                .external(name: ExternalDependencyName.swinject),
                .external(name: ExternalDependencyName.snapKit),
                .external(name: ExternalDependencyName.sfSafeSymbols),
                .external(name: ExternalDependencyName.then),
            ],
            hasUnitTests: true,
            additionalTestDependencies: [
                .target(name: "TestDoubles")
            ]
        )
        + Target.target(
            name: PROJECT_NAME,
            platform: .iOS,
            product: .app,
            bundleId: "\(BASIC_BUNDLE_ID)",
            deploymentTarget: DEPLOYMENT_TARGET,
            infoPlist: .file(path: "Resources/InfoPlist/Info.plist"),
            resources: [
                "Resources/Common/**",
                "Resources/InfoPlist/Product/**",
            ],
            scripts: [
                .pre(
                    path: "Scripts/generate_swifttlint_filelist.sh",
                    name: "Generate swiftlint file list",
                    basedOnDependencyAnalysis: false
                ),
                .post(
                    path: "Scripts/run_swiftlint.sh",
                    name: "Run swiftlint",
                    inputFileListPaths: ["build/build_phases/Sources_swiftlint.xcfilelist"],
                    outputFileListPaths: ["build/build_phases/Sources_swiftlint_static_output"],
                    basedOnDependencyAnalysis: true
                )
            ],
            dependencies: [.target(name: "iOSCore")],
            settings: .settings()
        )
        + Target.target(
            name: "\(PROJECT_NAME)Dev",
            platform: .iOS,
            product: .app,
            bundleId: "\(BASIC_BUNDLE_ID)Dev",
            deploymentTarget: DEPLOYMENT_TARGET,
            infoPlist: .file(path: "Resources/InfoPlist/Info.plist"),
            resources: [
                "Resources/Common/**",
                "Resources/InfoPlist/Dev/**",
            ],
            scripts: [
                .pre(
                    path: "Scripts/generate_swifttlint_filelist.sh",
                    name: "Generate swiftlint file list",
                    basedOnDependencyAnalysis: false
                ),
                .post(
                    path: "Scripts/run_swiftlint.sh",
                    name: "Run swiftlint",
                    inputFileListPaths: ["build/build_phases/Sources_swiftlint.xcfilelist"],
                    outputFileListPaths: ["build/build_phases/Sources_swiftlint_static_output"],
                    basedOnDependencyAnalysis: true
                )
            ],
            dependencies: [
                .target(name: "iOSCore"),
                .target(name: "LaunchArguments")
            ],
            settings: .settings()
        )
        + [
            Target.init(
                name: "\(PROJECT_NAME)UITests",
                platform: .iOS,
                product: .uiTests,
                bundleId: "\(BASIC_BUNDLE_ID)UITests",
                deploymentTarget: .iOS(targetVersion: "16.0", devices: .iphone),
                sources: "Tests/\(PROJECT_NAME)UITests/**",
                resources: "Resources/Localization/**",
                dependencies: [
                    .target(name: "\(PROJECT_NAME)Dev"),
                    .target(name: "LaunchArguments"),
                    .package(product: "Realm")
                ]
            )
        ]
    ]
    
    return targets.flatMap { $0 }
}

// MARK: - Project

let project: Project = .init(
    name: PROJECT_NAME,
    organizationName: ORGANIZATION,
    options: .options(automaticSchemesOptions: .disabled),
    packages: [
        .package(url: "https://github.com/realm/realm-swift.git", from: "10.42.0")
    ],
    settings: .settings(),
    targets: targets(),
    schemes: [
        .init(
            name: PROJECT_NAME,
            testAction: .testPlans([.relativeToRoot("TestPlans/WordChecker.xctestplan")]),
            runAction: .runAction(executable: "\(PROJECT_NAME)")
        ),
        .init(
            name: "\(PROJECT_NAME)Dev",
            testAction: .testPlans([.relativeToRoot("TestPlans/WordChecker.xctestplan")]),
            runAction: .runAction(executable: "\(PROJECT_NAME)Dev")
        ),
        .init(
            name: "\(PROJECT_NAME)IntergrationTests",
            testAction: .testPlans([.relativeToRoot("TestPlans/WordCheckerIntergrationTests.xctestplan")])
        ),
        .init(
            name: "Domain",
            buildAction: .buildAction(targets: ["Domain"]),
            testAction: .testPlans([.relativeToRoot("TestPlans/Domain.xctestplan")])
        ),
        .init(
            name: "Utility",
            buildAction: .buildAction(targets: ["Utility"]),
            testAction: .testPlans([.relativeToRoot("TestPlans/Utility.xctestplan")])
        ),
        .init(
            name: "State",
            buildAction: .buildAction(targets: ["State"])
        ),
        .init(
            name: "TestDoubles",
            buildAction: .buildAction(targets: ["TestDoubles"])
        ),
        .init(
            name: "iOSCore",
            buildAction: .buildAction(targets: ["iOSCore"])
        ),
        .init(
            name: "LaunchArguments",
            buildAction: .buildAction(targets: ["LaunchArguments"])
        ),
        .init(
            name: "RealmPlatform",
            buildAction: .buildAction(targets: ["RealmPlatform"])
        ),
        
    ],
    additionalFiles: [
        ".swiftlint.yml",
        ".swiftlint_precommit.yml",
        "TestPlans/",
        "Scripts/",
        ".gitignore",
    ],
    resourceSynthesizers: []
)
