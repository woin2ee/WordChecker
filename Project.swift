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
                .external(name: ExternalDependencyName.then),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "DataDriverTesting"),
                .target(name: "TestsSupport"),
                .external(name: ExternalDependencyName.rxBlocking),
            ],
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "DomainTesting",
            dependencies: [
                .target(name: "Domain"),
                .target(name: "DataDriverTesting"),
            ],
            appendSchemeTo: &disposedSchemes
        )
        + Target.module(
            name: "FoundationExtension",
            hasTests: true,
            appendSchemeTo: &schemes
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
            name: "DataDriver",
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
                .external(name: ExternalDependencyName.extendedUserDefaults),
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
            name: "DataDriverTesting",
            dependencies: [
                .target(name: "Domain"),
            ],
            appendSchemeTo: &disposedSchemes
        )
        + Target.module(
            name: "iOSSupport",
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
            ],
            appendSchemeTo: &disposedSchemes
        )
        + Target.module(
            name: "WordChecking",
            sourcesPrefix: "iOSScenes",
            resourceOptions: [.additional("Resources/iOSSupport/**")],
            dependencies: [
                .target(name: "Domain"),
                .target(name: "iOSSupport"),
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
            name: "WordCheckingExample",
            product: .app,
            infoPlist: .file(path: "Resources/InfoPlist/InfoExample.plist"),
            sourcesPrefix: "iOSScenes",
            dependencies: [
                .target(name: "WordChecking"),
                .target(name: "DomainTesting"),
            ],
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "WordList",
            sourcesPrefix: "iOSScenes",
            resourceOptions: [.additional("Resources/iOSSupport/**")],
            dependencies: [
                .target(name: "Domain"),
                .target(name: "iOSSupport"),
                .target(name: "WordDetail"),
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
            name: "WordDetail",
            sourcesPrefix: "iOSScenes",
            resourceOptions: [.additional("Resources/iOSSupport/**")],
            dependencies: [
                .target(name: "Domain"),
                .target(name: "iOSSupport"),
                .external(name: ExternalDependencyName.rxSwift),
                .external(name: ExternalDependencyName.rxCocoa),
                .external(name: ExternalDependencyName.rxUtilityDynamic),
                .external(name: ExternalDependencyName.reactorKit),
                .external(name: ExternalDependencyName.snapKit),
                .external(name: ExternalDependencyName.then),
                .external(name: ExternalDependencyName.toast),
                .external(name: ExternalDependencyName.swinject),
                .external(name: ExternalDependencyName.swinjectExtension),
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
            name: "WordAddition",
            sourcesPrefix: "iOSScenes",
            resourceOptions: [.additional("Resources/iOSSupport/**")],
            dependencies: [
                .target(name: "Domain"),
                .target(name: "iOSSupport"),
                .target(name: "FoundationExtension"),
                .external(name: ExternalDependencyName.rxSwift),
                .external(name: ExternalDependencyName.rxCocoa),
                .external(name: ExternalDependencyName.rxUtilityDynamic),
                .external(name: ExternalDependencyName.reactorKit),
                .external(name: ExternalDependencyName.snapKit),
                .external(name: ExternalDependencyName.then),
                .external(name: ExternalDependencyName.toast),
                .external(name: ExternalDependencyName.swinject),
                .external(name: ExternalDependencyName.swinjectExtension),
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
            name: "UserSettings",
            sourcesPrefix: "iOSScenes",
            resourceOptions: [.additional("Resources/iOSSupport/**")],
            dependencies: [
                .target(name: "Domain"),
                .target(name: "iOSSupport"),
                .external(name: ExternalDependencyName.rxSwift),
                .external(name: ExternalDependencyName.rxCocoa),
                .external(name: ExternalDependencyName.rxUtilityDynamic),
                .external(name: ExternalDependencyName.reactorKit),
                .external(name: ExternalDependencyName.snapKit),
                .external(name: ExternalDependencyName.then),
                .external(name: ExternalDependencyName.toast),
                .external(name: ExternalDependencyName.swinject),
                .external(name: ExternalDependencyName.swinjectExtension),
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
            name: "UserSettingsExample",
            product: .app,
            infoPlist: .file(path: "Resources/InfoPlist/InfoExample.plist"),
            sourcesPrefix: "iOSScenes",
            dependencies: [
                .target(name: "UserSettings"),
                .target(name: "DomainTesting"),
            ],
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "LanguageSetting",
            sourcesPrefix: "iOSScenes",
            resourceOptions: [.additional("Resources/iOSSupport/**")],
            dependencies: [
                .target(name: "Domain"),
                .target(name: "iOSSupport"),
                .external(name: ExternalDependencyName.rxSwift),
                .external(name: ExternalDependencyName.rxCocoa),
                .external(name: ExternalDependencyName.rxUtilityDynamic),
                .external(name: ExternalDependencyName.reactorKit),
                .external(name: ExternalDependencyName.snapKit),
                .external(name: ExternalDependencyName.then),
                .external(name: ExternalDependencyName.toast),
                .external(name: ExternalDependencyName.swinject),
                .external(name: ExternalDependencyName.swinjectExtension),
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
            name: "PushNotificationSettings",
            sourcesPrefix: "iOSScenes",
            resourceOptions: [.additional("Resources/iOSSupport/**")],
            dependencies: [
                .target(name: "iOSSupport"),
                .external(name: ExternalDependencyName.rxSwift),
                .external(name: ExternalDependencyName.rxCocoa),
                .external(name: ExternalDependencyName.rxUtilityDynamic),
                .external(name: ExternalDependencyName.reactorKit),
                .external(name: ExternalDependencyName.swinject),
                .external(name: ExternalDependencyName.swinjectExtension),
            ],
            hasTests: true,
            additionalTestDependencies: [
                .target(name: "DomainTesting"),
                .external(name: ExternalDependencyName.rxBlocking),
            ],
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "PushNotificationSettingsExample",
            product: .app,
            infoPlist: .file(path: "Resources/InfoPlist/InfoExample.plist"),
            sourcesPrefix: "iOSScenes",
            dependencies: [
                .target(name: "PushNotificationSettings"),
                .target(name: "DomainTesting"),
            ],
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "iPhoneDriver",
            dependencies: [
                .target(name: "iOSSupport"),
                .target(name: "WordChecking"),
                .target(name: "WordList"),
                .target(name: "WordAddition"),
                .target(name: "WordDetail"),
                .target(name: "UserSettings"),
                .target(name: "LanguageSetting"),
                .target(name: "PushNotificationSettings"),
                .external(name: ExternalDependencyName.swinject),
                .external(name: ExternalDependencyName.swinjectDIContainer),
                .external(name: ExternalDependencyName.sfSafeSymbols),
                .external(name: ExternalDependencyName.then),

            ],
            appendSchemeTo: &disposedSchemes
        )
        + Target.module(
            name: PROJECT_NAME,
            product: .app,
            bundleId: BASIC_BUNDLE_ID,
            infoPlist: .file(path: "Resources/InfoPlist/Info.plist"),
            resourceOptions: [
                .common,
                .additional("Resources/InfoPlist/Product/**"),
            ],
            dependencies: [
                .target(name: "DataDriver"),
                .target(name: "iPhoneDriver"),
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
                .common,
                .additional("Resources/InfoPlist/Dev/**"),
            ],
            dependencies: [
                .target(name: "DataDriver"),
                .target(name: "iPhoneDriver"),
            ],
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
                    .target(name: "iOSSupport"),
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
    ],
    settings: .settings(),
    targets: targets(),
    schemes: schemes + [
        .init(
            name: PROJECT_NAME,
            buildAction: .buildAction(targets: ["\(PROJECT_NAME)"]),
            testAction: .testPlans([.relativeToRoot("TestPlans/WordChecker.xctestplan")]),
            runAction: .runAction(executable: "\(PROJECT_NAME)"),
            profileAction: .profileAction(executable: "\(PROJECT_NAME)")
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
