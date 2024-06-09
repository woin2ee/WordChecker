import ExternalDependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

var schemes: [Scheme] = []
var disposedSchemes: [Scheme] = []

// MARK: - Targets

func commonTargets() -> [Target] {
    [
        Target.makeCommonFramework(
            name: Module.container,
            dependencies: [
                .external(name: .swinject),
            ],
            appendSchemeTo: &schemes
        ),
        
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
                .external(name: .foundationPlus),
                .external(name: .swinject),
                .external(name: .swinjectExtension),
                .external(name: .rxSwift),
                .external(name: .rxSwiftSugarDynamic),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeCommonFramework(
            name: Module.domain.wordManagement,
            dependencies: [
                .target(name: Module.domain.core),
                .external(name: .realm),
                .external(name: .realmSwift),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "\(Module.domain.wordManagement)Testing"),
                .external(name: .realm),
                .external(name: .realmSwift),
            ],
            withTesting: true,
            appendSchemeTo: &schemes
        ),
        Target.makeCommonFramework(
            name: Module.domain.wordMemorization,
            dependencies: [
                .target(name: Module.domain.core),
            ],
            hasTests: true,
            withTesting: true,
            appendSchemeTo: &schemes
        ),
        Target.makeCommonFramework(
            name: Module.domain.googleDrive,
            dependencies: [
                .target(name: Module.domain.core),
                .external(name: .googleAPIClientForRESTCore),
                .external(name: .googleAPIClientForREST_Drive),
                .external(name: .googleSignIn),
            ],
            withTesting: true,
            appendSchemeTo: &schemes
        ),
        Target.makeCommonFramework(
            name: Module.domain.userSettings,
            dependencies: [
                .target(name: Module.domain.core),
                .external(name: .extendedUserDefaults),
            ],
            hasTests: true,
            withTesting: true,
            appendSchemeTo: &schemes
        ),
        Target.makeCommonFramework(
            name: Module.domain.localNotification,
            dependencies: [
                .target(name: Module.domain.core),
                .external(name: .extendedUserDefaults),
            ],
            resourceOptions: [.own],
            withTesting: true,
            appendSchemeTo: &schemes
        ),
        
        // MARK: UseCase
        
        Target.makeCommonFramework(
            name: Module.useCase.word,
            dependencies: [
                .target(name: Module.domain.wordManagement),
                .target(name: Module.domain.wordMemorization),
                .target(name: Module.domain.localNotification),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "\(Module.domain.wordManagement)Testing"),
                .target(name: "\(Module.domain.wordMemorization)Testing"),
                .target(name: "\(Module.domain.localNotification)Testing"),
                .external(name: .rxBlocking),
            ],
            withTesting: true,
            additionalTestingDependencies: [
                .target(name: "\(Module.domain.wordManagement)Testing"),
                .target(name: "\(Module.domain.wordMemorization)Testing"),
                .target(name: "\(Module.domain.localNotification)Testing"),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeCommonFramework(
            name: Module.useCase.googleDrive,
            dependencies: [
                .target(name: Module.domain.googleDrive),
                .target(name: Module.domain.localNotification),
                .target(name: Module.domain.wordManagement),
                .target(name: Module.domain.wordMemorization),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "Domain_GoogleDriveTesting"),
                .target(name: "Domain_LocalNotificationTesting"),
                .target(name: "\(Module.domain.wordManagement)Testing"),
                .external(name: .rxBlocking),
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
                .external(name: .rxBlocking),
            ],
            withTesting: true,
            appendSchemeTo: &schemes
        ),
        Target.makeCommonFramework(
            name: "UseCase_LocalNotification",
            dependencies: [
                .target(name: Module.domain.localNotification),
                .target(name: Module.domain.wordManagement),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "Domain_LocalNotificationTesting"),
                .target(name: "\(Module.domain.wordManagement)Testing"),
                .external(name: .rxBlocking),
            ],
            withTesting: true,
            appendSchemeTo: &schemes
        ),
        
        Target.makeCommonFramework(
            name: Module.testsSupport,
            dependencies: [
                .external(name: .rxSwift),
                .external(name: .rxTest),
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
                .target(name: Module.testsSupport),
            ]
        ),
        Target.target(
            name: "SnapshotGenerator",
            destinations: .iOS,
            product: .uiTests,
            bundleId: "\(BASIC_BUNDLE_ID).SnapshotGenerator",
            deploymentTargets: .iOS(MINIMUM_IOS_VERSION),
            sources: "Tests/SnapshotGenerator/**",
            dependencies: [
                .target(name: "\(PROJECT_NAME)Dev"),
                .target(name: Module.iOSSupport),
                .target(name: Module.utility),
                .target(name: Module.testsSupport),
            ]
        ),
        Target.target(
            name: "IOSSceneIntegrationTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(BASIC_BUNDLE_ID).IOSSceneIntegrationTests",
            deploymentTargets: .iOS(MINIMUM_IOS_VERSION),
            sources: "Tests/IOSSceneIntegrationTests/**",
            dependencies: [
                .target(name: Module.iOSScene.wordChecking),
                .target(name: Module.iOSScene.wordList),
                .target(name: Module.iOSScene.wordDetail),
                .target(name: Module.iOSScene.wordAddition),
                .target(name: Module.iOSScene.userSettings),
                .target(name: Module.iOSSupport),
                .target(name: Module.testsSupport),
                .external(name: .rxBlocking),
                .external(name: .rxTest),
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
                .target(name: Module.domain.wordManagement),
                .target(name: Module.useCase.googleDrive),
                .target(name: Module.useCase.localNotification),
                .target(name: Module.useCase.userSettings),
                .target(name: Module.useCase.word),
                .external(name: .inject),
                .external(name: .pinLayout),
                .external(name: .rxSwift),
                .external(name: .rxCocoa),
                .external(name: .rxSwiftSugarDynamic),
                .external(name: .reactorKit),
                .external(name: .snapKit),
                .external(name: .then),
                .external(name: .toast),
                .external(name: .sfSafeSymbols),
                .external(name: .swinject),
                .external(name: .swinjectExtension),
                .external(name: .uiKitPlus),
                .external(name: .swiftCollections),
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
                .target(name: "\(Module.domain.wordManagement)Testing"),
                .target(name: "\(Module.domain.wordMemorization)Testing"),
                .target(name: "\(Module.domain.localNotification)Testing"),
                .target(name: "UseCase_UserSettingsTesting"),
                .target(name: "UseCase_WordTesting"),
                .external(name: .rxBlocking),
                .external(name: .rxTest),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeTargets(
            name: "IOSScene_WordCheckingExample",
            destinations: .iOS,
            product: .app,
            deploymentTargets: .iOS(MINIMUM_IOS_VERSION),
            infoPlist: .file(path: .path(Constant.Path.iOSExampleInfoPlist)),
            dependencies: [
                .target(name: Module.iOSScene.wordChecking),
                .target(name: "UseCase_WordTesting"),
                .target(name: "UseCase_UserSettingsTesting"),
            ],
            settings: .settings(
                base: SettingsDictionary().automaticCodeSigning(devTeam: Constant.Security.TEAM_ID)
            ),
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
                .target(name: "\(Module.domain.wordManagement)Testing"),
                .external(name: .rxBlocking),
                .external(name: .rxTest),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeTargets(
            name: "\(Module.iOSScene.wordList)Example",
            destinations: .iOS,
            product: .app,
            deploymentTargets: .iOS(MINIMUM_IOS_VERSION),
            infoPlist: .file(path: .path(Constant.Path.iOSExampleInfoPlist)),
            dependencies: [
                .target(name: Module.iOSScene.wordList),
                .target(name: "UseCase_WordTesting"),
            ],
            settings: .settings(
                base: SettingsDictionary().automaticCodeSigning(devTeam: Constant.Security.TEAM_ID)
            ),
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
                .external(name: .rxBlocking),
                .external(name: .rxTest),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeTargets(
            name: "\(Module.iOSScene.wordDetail)Example",
            destinations: .iOS,
            product: .app,
            deploymentTargets: .iOS(MINIMUM_IOS_VERSION),
            infoPlist: .file(path: .path(Constant.Path.iOSExampleInfoPlist)),
            dependencies: [
                .target(name: Module.iOSScene.wordDetail),
                .target(name: "UseCase_WordTesting"),
            ],
            settings: .settings(
                base: SettingsDictionary().automaticCodeSigning(devTeam: Constant.Security.TEAM_ID)
            ),
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
                .external(name: .rxBlocking),
                .external(name: .rxTest),
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
                .external(name: .rxBlocking),
                .external(name: .rxTest),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeTargets(
            name: "IOSScene_UserSettingsExample",
            destinations: .iOS,
            product: .app,
            deploymentTargets: .iOS(MINIMUM_IOS_VERSION),
            infoPlist: .file(path: .path(Constant.Path.iOSExampleInfoPlist)),
            dependencies: [
                .target(name: Module.iOSScene.userSettings),
                .target(name: "UseCase_LocalNotificationTesting"),
                .target(name: "UseCase_GoogleDriveTesting"),
                .target(name: "UseCase_UserSettingsTesting"),
            ],
            settings: .settings(
                base: SettingsDictionary().automaticCodeSigning(devTeam: Constant.Security.TEAM_ID)
            ),
            appendSchemeTo: &schemes
        ),
        Target.makeTargets(
            name: "TestingApp",
            destinations: .iOS,
            product: .app,
            deploymentTargets: .iOS(MINIMUM_IOS_VERSION),
            infoPlist: .file(path: .path(Constant.Path.iOSExampleInfoPlist)),
            dependencies: [
                .target(name: Module.iOSSupport),
            ],
            settings: .settings(
                base: SettingsDictionary().automaticCodeSigning(devTeam: Constant.Security.TEAM_ID)
            ),
            appendSchemeTo: &schemes
        ),
        Target.makeTargets(
            name: Module.iOSDriver,
            destinations: [.iPhone, .iPad],
            product: .framework,
            deploymentTargets: .iOS(MINIMUM_IOS_VERSION),
            dependencies: [
                .target(name: Module.container),
                .target(name: Module.iOSSupport),
                .target(name: Module.iOSScene.wordChecking),
                .target(name: Module.iOSScene.wordList),
                .target(name: Module.iOSScene.wordAddition),
                .target(name: Module.iOSScene.wordDetail),
                .target(name: Module.iOSScene.userSettings),
            ],
            appendSchemeTo: &schemes
        ),
        Target.makeTargets(
            name: Module.iPhoneDriver,
            destinations: [.iPhone],
            product: .framework,
            deploymentTargets: .iOS(MINIMUM_IOS_VERSION),
            dependencies: [
                .target(name: Module.container),
                .target(name: Module.iOSDriver),
            ],
            resourceOptions: [.own],
            appendSchemeTo: &schemes
        ),
        Target.makeTargets(
            name: Module.iPadDriver,
            destinations: [.iPad],
            product: .framework,
            deploymentTargets: .iOS(MINIMUM_IOS_VERSION),
            dependencies: [
                .target(name: Module.container),
                .target(name: Module.iOSDriver),
            ],
            resourceOptions: [.own],
            appendSchemeTo: &schemes
        ),
        Target.makeTargets(
            name: PROJECT_NAME,
            destinations: [.iPhone, .iPad],
            product: .app,
            bundleID: BASIC_BUNDLE_ID,
            deploymentTargets: .iOS(MINIMUM_IOS_VERSION),
            infoPlist: .file(path: .path(Constant.Path.iOSInfoPlist)),
            dependencies: [
                .target(name: Module.iPhoneDriver),
                .target(name: Module.iPadDriver),
            ],
            settings: .settings(
                base: SettingsDictionary()
                    .automaticCodeSigning(devTeam: Constant.Security.TEAM_ID),
                configurations: [
                    .debug(name: .debug),
                    .release(
                        name: .release,
                        xcconfig: .relativeToRoot("Sources/WordChecker/ReleaseConfig.xcconfig")
                    ),
                ]
            ),
            resourceOptions: [.own, .common],
            appendSchemeTo: &schemes
        ),
        Target.makeTargets(
            name: "\(PROJECT_NAME)Dev",
            destinations: [.iPhone, .iPad],
            product: .app,
            bundleID: "\(BASIC_BUNDLE_ID)Dev",
            deploymentTargets: .iOS(MINIMUM_IOS_VERSION),
            infoPlist: .file(path: .path(Constant.Path.iOSInfoPlist)),
            dependencies: [
                .target(name: Module.iPhoneDriver),
                .target(name: Module.iPadDriver),
            ],
            settings: .settings(
                base: SettingsDictionary()
                    .automaticCodeSigning(devTeam: Constant.Security.TEAM_ID),
                configurations: [
                    .debug(
                        name: .debug,
                        xcconfig: .relativeToRoot("Sources/WordCheckerDev/DebugConfig.xcconfig")
                    ),
                    .release(name: .release),
                ]
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
        .target(name: Module.container),
        .target(name: Module.domain.wordManagement),
        .target(name: Module.useCase.word),
        .external(name: .then),
        .external(name: .swinject),
        .external(name: .swinjectExtension),
        .external(name: .pinLayout),
        .external(name: .rxSwift),
        .external(name: .rxSwiftSugarDynamic),
        .external(name: .rxCocoa),
        .external(name: .reactorKit),
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
    settings: .settings(
        base: ["SWIFT_EMIT_LOC_STRINGS": true],
        debug: SettingsDictionary()
            .otherLinkerFlags([
                "-Xlinker",
                "-interposable"
            ])
    ),
    targets: allTargets,
    schemes: schemes + [
        .scheme(
            name: PROJECT_NAME,
            buildAction: .buildAction(targets: ["\(PROJECT_NAME)"]),
            runAction: .runAction(
                configuration: .release,
                attachDebugger: false,
                executable: "\(PROJECT_NAME)"
            ),
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
            name: "IntegrationTests",
            testAction: .testPlans([.relativeToRoot("TestPlans/IntegrationTests.xctestplan")])
        ),
        .scheme(
            name: "snapshot-generator",
            buildAction: .buildAction(targets: ["SnapshotGenerator"]),
            testAction: .targets(
                [.testableTarget(target: "SnapshotGenerator")],
                attachDebugger: false
            )
        )
    ],
    additionalFiles: [
        ".swiftlint.yml",
        "TestPlans/",
        "Scripts/",
        ".gitignore",
        "Project.swift",
        "CHANGELOG.md",
    ],
    resourceSynthesizers: []
)
