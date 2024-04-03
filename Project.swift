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
        // MARK: Utility
        
        Target.makeCommonFramework(
            name: Module.utility,
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
        
        // MARK: Domain
        
        Target.makeCommonFramework(
            name: Module.domain.core,
            dependencies: [
                .target(name: Module.utility),
                .external(name: ExternalDependencyName.foundationPlus),
                .external(name: ExternalDependencyName.swinject),
                .external(name: ExternalDependencyName.swinjectExtension),
                .external(name: ExternalDependencyName.rxSwift),
                .external(name: ExternalDependencyName.rxSwiftSugarDynamic),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeCommonFramework(
            name: Module.domain.word,
            dependencies: [
                .target(name: Module.domain.core),
                .package(product: ExternalDependencyName.realm),
                .package(product: ExternalDependencyName.realmSwift),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "Domain_WordTesting"),
            ],
            withTesting: true,
            appendSchemeTo: &schemes
        ),
        Target.makeCommonFramework(
            name: Module.domain.googleDrive,
            dependencies: [
                .target(name: Module.domain.core),
                .package(product: ExternalDependencyName.googleAPIClientForRESTCore),
                .package(product: ExternalDependencyName.googleAPIClientForREST_Drive),
                .package(product: ExternalDependencyName.googleSignIn),
            ],
            withTesting: true,
            appendSchemeTo: &schemes
        ),
        Target.makeCommonFramework(
            name: Module.domain.userSettings,
            dependencies: [
                .target(name: Module.domain.core),
                .external(name: ExternalDependencyName.extendedUserDefaults),
            ],
            hasTests: true,
            withTesting: true,
            appendSchemeTo: &schemes
        ),
        Target.makeCommonFramework(
            name: Module.domain.localNotification,
            dependencies: [
                .target(name: Module.domain.core),
                .external(name: ExternalDependencyName.extendedUserDefaults),
            ],
            resourceOptions: [.own],
            withTesting: true,
            appendSchemeTo: &schemes
        ),
        
        // MARK: UseCase
        
        Target.makeCommonFramework(
            name: Module.useCase.word,
            dependencies: [
                .target(name: Module.domain.word),
                .target(name: Module.domain.localNotification),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "Domain_WordTesting"),
                .target(name: "Domain_LocalNotificationTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
            ],
            withTesting: true,
            appendSchemeTo: &schemes
        ),
        Target.makeCommonFramework(
            name: Module.useCase.googleDrive,
            dependencies: [
                .target(name: Module.domain.googleDrive),
                .target(name: Module.domain.localNotification),
                .target(name: Module.domain.word),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "Domain_GoogleDriveTesting"),
                .target(name: "Domain_LocalNotificationTesting"),
                .target(name: "Domain_WordTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
            ],
            withTesting: true,
            appendSchemeTo: &schemes
        ),
        Target.makeCommonFramework(
            name: Module.useCase.userSettings,
            dependencies: [
                .target(name: Module.domain.userSettings),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "Domain_UserSettingsTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
            ],
            withTesting: true,
            appendSchemeTo: &schemes
        ),
        Target.makeCommonFramework(
            name: "UseCase_LocalNotification",
            dependencies: [
                .target(name: Module.domain.localNotification),
                .target(name: Module.domain.word),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "Domain_LocalNotificationTesting"),
                .target(name: "Domain_WordTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
            ],
            withTesting: true,
            appendSchemeTo: &schemes
        ),
        
        Target.makeCommonFramework(
            name: Module.testsSupport,
            dependencies: [
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
                .target(name: Module.iOSSupport),
                .target(name: Module.utility),
            ]
        ),
    ] + [
        Target.makeIOSFramework(
            name: Module.iOSSupport,
            dependencies: [
                .target(name: Module.utility),
                .target(name: Module.domain.googleDrive),
                .target(name: Module.domain.localNotification),
                .target(name: Module.domain.userSettings),
                .target(name: Module.domain.word),
                .target(name: Module.useCase.googleDrive),
                .target(name: Module.useCase.localNotification),
                .target(name: Module.useCase.userSettings),
                .target(name: Module.useCase.word),
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
                .external(name: ExternalDependencyName.swinjectDIContainer),
                .external(name: ExternalDependencyName.uiKitPlus),
                .package(product: ExternalDependencyName.swiftCollections),
            ],
            resourceOptions: [.own],
            appendSchemeTo: &schemes
        ),
        Target.makeIOSFramework(
            name: Module.iOSScene.wordChecking,
            dependencies: [
                .target(name: Module.iOSSupport),
            ],
            resourceOptions: [.own],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "UseCase_UserSettingsTesting"),
                .target(name: "UseCase_WordTesting"),
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
                .target(name: Module.iOSScene.wordChecking),
                .target(name: "UseCase_WordTesting"),
                .target(name: "UseCase_UserSettingsTesting"),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeIOSFramework(
            name: Module.iOSScene.wordList,
            dependencies: [
                .target(name: Module.iOSSupport),
            ],
            resourceOptions: [.own],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "UseCase_WordTesting"),
                .target(name: "Domain_LocalNotificationTesting"),
                .target(name: "Domain_WordTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
                .external(name: ExternalDependencyName.rxTest),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeIOSFramework(
            name: Module.iOSScene.wordDetail,
            dependencies: [
                .target(name: Module.iOSSupport),
            ],
            resourceOptions: [.own],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "UseCase_WordTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
                .external(name: ExternalDependencyName.rxTest),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeIOSFramework(
            name: Module.iOSScene.wordAddition,
            dependencies: [
                .target(name: Module.iOSSupport),
            ],
            resourceOptions: [.own],
            hasTests: true,
            additionalTestDependencies: [
                .external(name: ExternalDependencyName.rxBlocking),
                .external(name: ExternalDependencyName.rxTest),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeIOSFramework(
            name: Module.iOSScene.userSettings,
            dependencies: [
                .target(name: Module.iOSSupport),
            ],
            resourceOptions: [.own],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: Module.testsSupport),
                .target(name: "UseCase_UserSettingsTesting"),
                .target(name: "UseCase_GoogleDriveTesting"),
                .target(name: "UseCase_LocalNotificationTesting"),
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
                .target(name: Module.iOSScene.userSettings),
                .target(name: "UseCase_LocalNotificationTesting"),
                .target(name: "UseCase_GoogleDriveTesting"),
                .target(name: "UseCase_UserSettingsTesting"),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeTargets(
            name: Module.iPhoneDriver,
            destinations: [.iPhone],
            product: .framework,
            deploymentTargets: .iOS(MINIMUM_IOS_VERSION),
            dependencies: [
                .target(name: Module.iOSSupport),
                .target(name: Module.iOSScene.wordChecking),
                .target(name: Module.iOSScene.wordList),
                .target(name: Module.iOSScene.wordAddition),
                .target(name: Module.iOSScene.wordDetail),
                .target(name: Module.iOSScene.userSettings),
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
            dependencies: [.target(name: Module.iPhoneDriver),],
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
            dependencies: [.target(name: Module.iPhoneDriver),],
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
        .target(name: Module.domain.word),
        .target(name: Module.useCase.word),
        .external(name: ExternalDependencyName.then),
        .external(name: ExternalDependencyName.swinject),
        .external(name: ExternalDependencyName.swinjectExtension),
        .external(name: ExternalDependencyName.swinjectDIContainer),
        .external(name: ExternalDependencyName.pinLayout),
        .external(name: ExternalDependencyName.rxSwift),
        .external(name: ExternalDependencyName.rxSwiftSugarDynamic),
        .external(name: ExternalDependencyName.rxCocoa),
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
