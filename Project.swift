import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

// Local plugin loaded
let localHelper = LocalHelper(name: "MyPlugin")

// MARK: - Targets

// swiftlint:disable function_body_length
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
                .target(name: "Utility"),
            ],
            hasUnitTests: true,
            additionalTestDependencies: [
                .target(name: "Testing"),
                .external(name: ExternalDependencyName.rxBlocking),
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
                .target(name: "Domain"),
            ]
        )
        + Target.target(
            name: "State",
            platform: .iOS,
            product: .framework,
            deploymentTarget: DEPLOYMENT_TARGET,
            dependencies: [
                .target(name: "Domain"),
                .target(name: "Utility"),
            ]
        )
        + Target.target(
            name: "UserDefaultsPlatform",
            platform: .iOS,
            product: .framework,
            deploymentTarget: DEPLOYMENT_TARGET,
            dependencies: [
                .external(name: ExternalDependencyName.rxSwift),
                .external(name: ExternalDependencyName.rxUtilityDynamic),
                .target(name: "Domain"),
            ]
        )
        + Target.target(
            name: "Utility",
            platform: .iOS,
            product: .framework,
            deploymentTarget: DEPLOYMENT_TARGET,
            scripts: [
                .pre(
                    path: "Scripts/set_githooks_path.sh",
                    name: "Set githooks path",
                    basedOnDependencyAnalysis: false
                ),
            ],
            hasUnitTests: true
        )
        + Target.target(
            name: "LaunchArguments",
            platform: .iOS,
            product: .framework,
            deploymentTarget: DEPLOYMENT_TARGET
        )
        + Target.target(
            name: "Localization",
            platform: .iOS,
            product: .framework,
            deploymentTarget: DEPLOYMENT_TARGET,
            resources: ["Resources/Localization/**"]
        )
        + Target.target(
            name: "Testing",
            platform: .iOS,
            product: .framework,
            deploymentTarget: DEPLOYMENT_TARGET,
            dependencies: [
                .target(name: "Domain"),
                .target(name: "State"),
                .target(name: "Utility"),
                .target(name: "iOSCore"),
                .external(name: ExternalDependencyName.rxSwift),
            ]
        )
        + Target.target(
            name: "iOSCore",
            platform: .iOS,
            product: .framework,
            deploymentTarget: DEPLOYMENT_TARGET,
            resources: [
                "Resources/Common/**"
            ],
            dependencies: [
                .target(name: "Domain"),
                .target(name: "RealmPlatform"),
                .target(name: "State"),
                .target(name: "Utility"),
                .target(name: "Localization"),
                .external(name: ExternalDependencyName.rxSwift),
                .external(name: ExternalDependencyName.rxCocoa),
                .external(name: ExternalDependencyName.rxUtilityDynamic),
                .external(name: ExternalDependencyName.swinject),
                .external(name: ExternalDependencyName.snapKit),
                .external(name: ExternalDependencyName.sfSafeSymbols),
                .external(name: ExternalDependencyName.then),
                .external(name: ExternalDependencyName.toast),
            ],
            hasUnitTests: true,
            additionalTestDependencies: [
                .target(name: "Testing")
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
            dependencies: [
                .target(name: "iOSCore"),
                .target(name: "LaunchArguments"),
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
                dependencies: [
                    .target(name: "\(PROJECT_NAME)Dev"),
                    .target(name: "iOSCore"),
                    .target(name: "LaunchArguments"),
                    .target(name: "Localization"),
                    .package(product: "Realm"),
                ]
            ),
        ],
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
            name: "\(PROJECT_NAME)Dev_InMemoryDB",
            testAction: .testPlans([.relativeToRoot("TestPlans/WordChecker.xctestplan")]),
            runAction: .runAction(
                executable: "\(PROJECT_NAME)Dev",
                arguments: .init(launchArguments: [
                    .init(name: "-useInMemoryDatabase", isEnabled: true)
                ])
            )
        ),
        .init(
            name: "\(PROJECT_NAME)Dev_SampleDB",
            testAction: .testPlans([.relativeToRoot("TestPlans/WordChecker.xctestplan")]),
            runAction: .runAction(
                executable: "\(PROJECT_NAME)Dev",
                arguments: .init(launchArguments: [
                    .init(name: "-sampledDatabase", isEnabled: true)
                ])
            )
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
            name: "UserDefaultsPlatform",
            buildAction: .buildAction(targets: ["UserDefaultsPlatform"])
        ),
        .init(
            name: "Testing",
            buildAction: .buildAction(targets: ["Testing"])
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
        .init(
            name: "Localization",
            buildAction: .buildAction(targets: ["Localization"])
        ),

    ],
    additionalFiles: [
        ".swiftlint.yml",
        "TestPlans/",
        "Scripts/",
        ".gitignore",
    ],
    resourceSynthesizers: []
)
