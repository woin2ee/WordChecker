import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

// Local plugin loaded
let localHelper = LocalHelper(name: "MyPlugin")

var schemes: [Scheme] = []
var disposedSchemes: [Scheme] = []

// MARK: - Targets

func commonTargets() -> [Target] {
    [
        Target.makeCommonFramework(
            name: "Domain",
            dependencies: [
                .target(name: "Utility"),
                .external(name: ExternalDependencyName.rxSwift, condition: nil),
                .external(name: ExternalDependencyName.rxSwiftSugarDynamic),
                .external(name: ExternalDependencyName.swinject),
                .external(name: ExternalDependencyName.swinjectExtension),
                .external(name: ExternalDependencyName.foundationPlus),
            ],
            resourceOptions: [.own],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "TestsSupport"),
                .target(name: "DomainTesting"),
                .target(name: "InfrastructureTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeCommonFramework(
            name: "DomainTesting",
            dependencies: [
                .target(name: "Domain"),
                .target(name: "InfrastructureTesting"),
            ],
            appendSchemeTo: &disposedSchemes
        ),
        Target.makeCommonFramework(
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
        ),
        Target.makeCommonFramework(
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
                .external(name: ExternalDependencyName.rxSwiftSugarDynamic),
                .external(name: ExternalDependencyName.extendedUserDefaultsRxExtension),
                .external(name: ExternalDependencyName.swinject),
                .external(name: ExternalDependencyName.swinjectExtension),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .external(name: ExternalDependencyName.rxBlocking),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeCommonFramework(
            name: "InfrastructureTesting",
            dependencies: [
                .target(name: "Domain"),
            ],
            appendSchemeTo: &disposedSchemes
        ),
        Target.makeCommonFramework(
            name: "TestsSupport",
            dependencies: [
                .target(name: "Domain"),
                .external(name: ExternalDependencyName.rxSwift),
                .external(name: ExternalDependencyName.rxTest),
            ],
            settings: .settings(base: ["ENABLE_TESTING_SEARCH_PATHS": "YES"]),
            appendSchemeTo: &disposedSchemes
        ),
    ]
        .flatMap { $0 }
}

func iOSTargets() -> [Target] {
    [
        Target.target(
            name: "\(PROJECT_NAME)UITests",
            destinations: [.iPhone],
            product: .uiTests,
            bundleId: "\(BASIC_BUNDLE_ID)UITests",
            deploymentTargets: .iOS(MINIMUM_IOS_VERSION),
            sources: "Tests/\(PROJECT_NAME)UITests/**",
            dependencies: [
                .target(name: "\(PROJECT_NAME)Dev"),
                .target(name: "IOSSupport"),
                .target(name: "Utility"),
                .package(product: "Realm"),
                .package(product: ExternalDependencyName.googleAPIClientForRESTCore),
                .package(product: ExternalDependencyName.googleAPIClientForREST_Drive),
                .package(product: ExternalDependencyName.googleSignIn),
            ]
        ),
    ] + [
        Target.makeIOSFramework(
            name: "IOSSupport",
            dependencies: [
                .target(name: "Domain"),
                .target(name: "Utility"),
                .external(name: ExternalDependencyName.rxSwift),
                .external(name: ExternalDependencyName.rxCocoa),
                .external(name: ExternalDependencyName.rxSwiftSugarDynamic),
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
            resourceOptions: [.own],
            appendSchemeTo: &schemes
        ),
        Target.makeIOSFramework(
            name: "IOSScene_WordChecking",
            dependencies: [.target(name: "IOSSupport"),],
            resourceOptions: [.own],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "DomainTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
                .external(name: ExternalDependencyName.rxTest),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeTargets(
            name: "IOSScene_WordCheckingExample",
            destinations: .iOS,
            product: .app,
            deploymentTargets: .iOS(MINIMUM_IOS_VERSION),
            infoPlist: .file(path: .path(Constant.Path.iPhoneExampleInfoPlist)),
            dependencies: [
                .target(name: "IOSScene_WordChecking"),
                .target(name: "DomainTesting"),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeIOSFramework(
            name: "IOSScene_WordList",
            dependencies: [.target(name: "IOSSupport"),],
            resourceOptions: [.own],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "DomainTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
                .external(name: ExternalDependencyName.rxTest),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeIOSFramework(
            name: "IOSScene_WordDetail",
            dependencies: [.target(name: "IOSSupport"),],
            resourceOptions: [.own],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "DomainTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
                .external(name: ExternalDependencyName.rxTest),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeIOSFramework(
            name: "IOSScene_WordAddition",
            dependencies: [.target(name: "IOSSupport"),],
            resourceOptions: [.own],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "DomainTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
                .external(name: ExternalDependencyName.rxTest),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeIOSFramework(
            name: "IOSScene_UserSettings",
            dependencies: [.target(name: "IOSSupport"),],
            resourceOptions: [.own],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "DomainTesting"),
                .target(name: "TestsSupport"),
                .external(name: ExternalDependencyName.rxBlocking),
                .external(name: ExternalDependencyName.rxTest),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeTargets(
            name: "IOSScene_UserSettingsExample",
            destinations: .iOS,
            product: .app,
            deploymentTargets: .iOS(MINIMUM_IOS_VERSION),
            infoPlist: .file(path: .path(Constant.Path.iPhoneExampleInfoPlist)),
            dependencies: [
                .target(name: "IOSScene_UserSettings"),
                .target(name: "DomainTesting"),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeIOSFramework(
            name: "IOSScene_LanguageSetting",
            dependencies: [.target(name: "IOSSupport"),],
            resourceOptions: [.own],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "DomainTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
                .external(name: ExternalDependencyName.rxTest),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeIOSFramework(
            name: "IOSScene_ThemeSetting",
            dependencies: [.target(name: "IOSSupport"),],
            resourceOptions: [.own],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "DomainTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
                .external(name: ExternalDependencyName.rxTest),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeIOSFramework(
            name: "IOSScene_PushNotificationSettings",
            dependencies: [.target(name: "IOSSupport"),],
            resourceOptions: [.own],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "DomainTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeTargets(
            name: "IOSScene_PushNotificationSettingsExample",
            destinations: .iOS,
            product: .app,
            deploymentTargets: .iOS(MINIMUM_IOS_VERSION),
            infoPlist: .file(path: .path(Constant.Path.iPhoneExampleInfoPlist)),
            dependencies: [
                .target(name: "IOSScene_PushNotificationSettings"),
                .target(name: "DomainTesting"),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeIOSFramework(
            name: "IOSScene_GeneralSettings",
            dependencies: [.target(name: "IOSSupport"),],
            resourceOptions: [.own],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "DomainTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeTargets(
            name: "IPhoneDriver",
            destinations: [.iPhone],
            product: .framework,
            deploymentTargets: .iOS(MINIMUM_IOS_VERSION),
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
            resourceOptions: [.own],
            appendSchemeTo: &disposedSchemes
        ),
        Target.makeTargets(
            name: PROJECT_NAME,
            destinations: [.iPhone],
            product: .app,
            bundleID: BASIC_BUNDLE_ID,
            deploymentTargets: .iOS(MINIMUM_IOS_VERSION),
            infoPlist: .file(path: .path(Constant.Path.iPhoneInfoPlist)),
            dependencies: [.target(name: "IPhoneDriver"),],
            settings: .settings(
                base: SettingsDictionary().automaticCodeSigning(devTeam: Constant.Security.TEAM_ID)
            ),
            resourceOptions: [.own, .common],
            appendSchemeTo: &schemes
        ),
        Target.makeTargets(
            name: "\(PROJECT_NAME)Dev",
            destinations: [.iPhone],
            product: .app,
            bundleID: "\(BASIC_BUNDLE_ID)Dev",
            deploymentTargets: .iOS(MINIMUM_IOS_VERSION),
            infoPlist: .file(path: .path(Constant.Path.iPhoneInfoPlist)),
            dependencies: [.target(name: "IPhoneDriver"),],
            settings: .settings(
                base: SettingsDictionary().automaticCodeSigning(devTeam: Constant.Security.TEAM_ID)
            ),
            resourceOptions: [.own, .common],
            appendSchemeTo: &schemes
        ),
    ]
        .flatMap { $0 }
}

let macAppTargets = Target.makeTargets(
    name: "\(PROJECT_NAME)Mac",
    destinations: [.mac],
    product: .app,
    bundleID: "\(BASIC_BUNDLE_ID)Mac",
    deploymentTargets: .macOS(MINIMUM_MACOS_VERSION),
    infoPlist: .file(path: .path(Constant.Path.macInfoPlist)),
    entitlements: .file(path: .path(Constant.Path.macEntitlements)),
    dependencies: [
        .target(name: "Domain"),
        .target(name: "Infrastructure"),
        .external(name: ExternalDependencyName.then),
        .external(name: ExternalDependencyName.swinject),
        .external(name: ExternalDependencyName.swinjectExtension),
        .external(name: ExternalDependencyName.swinjectDIContainer),
        .external(name: ExternalDependencyName.pinLayout),
        .external(name: ExternalDependencyName.reactorKit),
    ],
    settings: .settings(),
    resourceOptions: [.own],
    appendSchemeTo: &schemes
)

let allTargets: [Target] = [
    commonTargets(),
    iOSTargets(),
    macAppTargets
]
    .flatMap { $0 }

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
    targets: allTargets,
    schemes: schemes + [
        .scheme(
            name: PROJECT_NAME,
            buildAction: .buildAction(targets: ["\(PROJECT_NAME)"]),
            runAction: .runAction(executable: "\(PROJECT_NAME)"),
            profileAction: .profileAction(executable: "\(PROJECT_NAME)")
        ),
        .scheme(
            name: "\(PROJECT_NAME)Dev",
            runAction: .runAction(executable: "\(PROJECT_NAME)Dev")
        ),
        .scheme(
            name: "\(PROJECT_NAME)Dev_InMemoryDB",
            runAction: .runAction(
                executable: "\(PROJECT_NAME)Dev",
                arguments: .arguments(launchArguments: [
                    .launchArgument(name: "-useInMemoryDatabase", isEnabled: true)
                ])
            )
        ),
        .scheme(
            name: "\(PROJECT_NAME)Dev_SampleDB",
            runAction: .runAction(
                executable: "\(PROJECT_NAME)Dev",
                arguments: .arguments(launchArguments: [
                    .launchArgument(name: "-sampledDatabase", isEnabled: true)
                ])
            )
        ),
        .scheme(
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
