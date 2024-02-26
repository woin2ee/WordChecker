import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

// Local plugin loaded
let localHelper = LocalHelper(name: "MyPlugin")

// MARK: - Targets

var schemes: [Scheme] = []
var disposedSchemes: [Scheme] = []

// swiftlint:disable:next function_body_length
func targets() -> [Target] {
    let targets =
    [
        Target.module(
            name: "Domain",
            resourceOptions: [.own],
            dependencies: [
                .target(name: "Utility"),
                .external(name: ExternalDependencyName.rxSwift),
                .external(name: ExternalDependencyName.rxUtilityDynamic),
                .external(name: ExternalDependencyName.swinject),
                .external(name: ExternalDependencyName.swinjectExtension),
                .external(name: ExternalDependencyName.foundationPlus),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "TestsSupport"),
                .target(name: "DomainTesting"),
                .target(name: "InfrastructureTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
            ],
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "DomainTesting",
            dependencies: [
                .target(name: "Domain"),
                .target(name: "InfrastructureTesting"),
            ],
            appendSchemeTo: &disposedSchemes
        )
        + Target.module(
            name: "Utility",
            scripts: [
                // 공동 작업자의 githook path 자동 세팅을 위함
                .pre(
                    path: "Scripts/set_githooks_path.sh",
                    name: "Set githooks path",
                    basedOnDependencyAnalysis: false
                ),
            ],
            hasTests: true,
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "Infrastructure",
            dependencies: [
                .target(name: "Domain"),
                .target(name: "Utility"),
                .package(product: ExternalDependencyName.realm),
                .package(product: ExternalDependencyName.realmSwift),
                .package(product: ExternalDependencyName.googleAPIClientForRESTCore),
                .package(product: ExternalDependencyName.googleAPIClientForREST_Drive),
                .package(product: ExternalDependencyName.googleSignIn),
                .external(name: ExternalDependencyName.rxSwift),
                .external(name: ExternalDependencyName.rxUtilityDynamic),
                .external(name: ExternalDependencyName.extendedUserDefaultsRxExtension),
                .external(name: ExternalDependencyName.swinject),
                .external(name: ExternalDependencyName.swinjectExtension),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .external(name: ExternalDependencyName.rxBlocking),
            ],
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "InfrastructureTesting",
            dependencies: [
                .target(name: "Domain"),
            ],
            appendSchemeTo: &disposedSchemes
        )
        + Target.module(
            name: "IOSSupport",
            resourceOptions: [.own],
            dependencies: [
                .target(name: "Domain"),
                .target(name: "Utility"),
                .external(name: ExternalDependencyName.rxSwift),
                .external(name: ExternalDependencyName.rxCocoa),
                .external(name: ExternalDependencyName.rxUtilityDynamic),
                .external(name: ExternalDependencyName.reactorKit),
                .external(name: ExternalDependencyName.snapKit),
                .external(name: ExternalDependencyName.then),
                .external(name: ExternalDependencyName.toast),
                .external(name: ExternalDependencyName.sfSafeSymbols),
                .external(name: ExternalDependencyName.swinject),
                .external(name: ExternalDependencyName.swinjectExtension),
                .external(name: ExternalDependencyName.uiKitPlus),
                .package(product: ExternalDependencyName.swiftCollections),
            ],
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "IOSScene_WordChecking",
            resourceOptions: [.own],
            dependencies: [
                .target(name: "IOSSupport"),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "DomainTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
                .external(name: ExternalDependencyName.rxTest),
            ],
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "IOSScene_WordCheckingExample",
            product: .app,
            infoPlist: .file(path: "Resources/InfoPlist/InfoExample.plist"),
            dependencies: [
                .target(name: "IOSScene_WordChecking"),
                .target(name: "DomainTesting"),
            ],
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "IOSScene_WordList",
            resourceOptions: [.own],
            dependencies: [
                .target(name: "IOSSupport"),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "DomainTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
                .external(name: ExternalDependencyName.rxTest),
            ],
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "IOSScene_WordDetail",
            resourceOptions: [.own],
            dependencies: [
                .target(name: "IOSSupport"),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "DomainTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
                .external(name: ExternalDependencyName.rxTest),
            ],
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "IOSScene_WordAddition",
            resourceOptions: [.own],
            dependencies: [
                .target(name: "IOSSupport"),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "DomainTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
                .external(name: ExternalDependencyName.rxTest),
            ],
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "IOSScene_UserSettings",
            resourceOptions: [.own],
            dependencies: [
                .target(name: "IOSSupport"),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "DomainTesting"),
                .target(name: "TestsSupport"),
                .external(name: ExternalDependencyName.rxBlocking),
                .external(name: ExternalDependencyName.rxTest),
            ],
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "IOSScene_UserSettingsExample",
            product: .app,
            infoPlist: .file(path: "Resources/InfoPlist/InfoExample.plist"),
            dependencies: [
                .target(name: "IOSScene_UserSettings"),
                .target(name: "DomainTesting"),
            ],
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "IOSScene_LanguageSetting",
            resourceOptions: [.own],
            dependencies: [
                .target(name: "IOSSupport"),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "DomainTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
                .external(name: ExternalDependencyName.rxTest),
            ],
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "IOSScene_ThemeSetting",
            resourceOptions: [.own],
            dependencies: [
                .target(name: "IOSSupport"),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "DomainTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
            ],
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "IOSScene_PushNotificationSettings",
            resourceOptions: [.own],
            dependencies: [
                .target(name: "IOSSupport"),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "DomainTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
            ],
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "IOSScene_PushNotificationSettingsExample",
            product: .app,
            infoPlist: .file(path: "Resources/InfoPlist/InfoExample.plist"),
            dependencies: [
                .target(name: "IOSScene_PushNotificationSettings"),
                .target(name: "DomainTesting"),
            ],
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "IOSScene_GeneralSettings",
            resourceOptions: [.own],
            dependencies: [
                .target(name: "IOSSupport"),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "DomainTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
            ],
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "IPhoneDriver",
            resourceOptions: [.own],
            dependencies: [
                .target(name: "IOSSupport"),
                .target(name: "IOSScene_WordChecking"),
                .target(name: "IOSScene_WordList"),
                .target(name: "IOSScene_WordAddition"),
                .target(name: "IOSScene_WordDetail"),
                .target(name: "IOSScene_UserSettings"),
                .target(name: "IOSScene_LanguageSetting"),
                .target(name: "IOSScene_PushNotificationSettings"),
                .target(name: "IOSScene_GeneralSettings"),
                .target(name: "Infrastructure"),
                .target(name: "IOSScene_ThemeSetting"),
                .external(name: ExternalDependencyName.swinjectDIContainer),
            ],
            appendSchemeTo: &disposedSchemes
        )
        + Target.module(
            name: PROJECT_NAME,
            product: .app,
            bundleId: BASIC_BUNDLE_ID,
            infoPlist: .file(path: "Resources/InfoPlist/Info.plist"),
            resourceOptions: [
                .own,
                .common,
            ],
            dependencies: [
                .target(name: "IPhoneDriver"),
            ],
            settings: .settings(),
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "\(PROJECT_NAME)Dev",
            product: .app,
            bundleId: "\(BASIC_BUNDLE_ID)Dev",
            infoPlist: .file(path: "Resources/InfoPlist/Info.plist"),
            resourceOptions: [
                .own,
                .common,
            ],
            dependencies: [
                .target(name: "IPhoneDriver"),
            ],
            settings: .settings(),
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "\(PROJECT_NAME)Mac",
            platform: .macOS,
            product: .app,
            bundleId: "\(BASIC_BUNDLE_ID)Mac",
            deploymentTarget: .macOS(targetVersion: "14.0.0"),
            resourceOptions: [.own],
            entitlements: nil,
            dependencies: [],
            settings: .settings(),
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "TestsSupport",
            dependencies: [
                .target(name: "Domain"),
                .external(name: ExternalDependencyName.rxSwift),
                .external(name: ExternalDependencyName.rxTest),
            ],
            settings: .settings(base: ["ENABLE_TESTING_SEARCH_PATHS": "YES"]),
            appendSchemeTo: &disposedSchemes
        )
        + [
            Target.init(
                name: "\(PROJECT_NAME)UITests",
                platform: .iOS,
                product: .uiTests,
                bundleId: "\(BASIC_BUNDLE_ID)UITests",
                deploymentTarget: DEPLOYMENT_TARGET,
                sources: "Tests/\(PROJECT_NAME)UITests/**",
                dependencies: [
                    .target(name: "\(PROJECT_NAME)Dev"),
                    .target(name: "IOSSupport"),
                    .target(name: "Utility"),
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
        .package(url: "https://github.com/realm/realm-swift.git", from: "10.42.0"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", from: "6.0.0"),
        .package(url: "https://github.com/google/google-api-objectivec-client-for-rest.git", from: "3.0.0"),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.0"),
    ],
    settings: .settings(
        base: ["SWIFT_EMIT_LOC_STRINGS": true]
    ),
    targets: targets(),
    schemes: schemes + [
        .init(
            name: PROJECT_NAME,
            buildAction: .buildAction(targets: ["\(PROJECT_NAME)"]),
            runAction: .runAction(executable: "\(PROJECT_NAME)"),
            profileAction: .profileAction(executable: "\(PROJECT_NAME)")
        ),
        .init(
            name: "\(PROJECT_NAME)Dev",
            runAction: .runAction(executable: "\(PROJECT_NAME)Dev")
        ),
        .init(
            name: "\(PROJECT_NAME)Dev_InMemoryDB",
            runAction: .runAction(
                executable: "\(PROJECT_NAME)Dev",
                arguments: .init(launchArguments: [
                    .init(name: "-useInMemoryDatabase", isEnabled: true)
                ])
            )
        ),
        .init(
            name: "\(PROJECT_NAME)Dev_SampleDB",
            runAction: .runAction(
                executable: "\(PROJECT_NAME)Dev",
                arguments: .init(launchArguments: [
                    .init(name: "-sampledDatabase", isEnabled: true)
                ])
            )
        ),
        .init(
            name: "IntergrationTests",
            testAction: .testPlans([.relativeToRoot("TestPlans/IntergrationTests.xctestplan")])
        ),
    ],
    additionalFiles: [
        ".swiftlint.yml",
        "TestPlans/",
        "Scripts/",
        ".gitignore",
        "Project.swift",
    ],
    resourceSynthesizers: []
)
