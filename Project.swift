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
            platform: .iOS,
            product: .framework,
            deploymentTarget: DEPLOYMENT_TARGET,
            resourceOptions: [.default],
            dependencies: [
                .external(name: ExternalDependencyName.rxSwift),
                .external(name: ExternalDependencyName.rxUtilityDynamic),
                .target(name: "Utility"),
            ],
            hasUnitTests: true,
            additionalTestDependencies: [
                .target(name: "Testing"),
                .external(name: ExternalDependencyName.rxBlocking),
            ],
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "DataDriver",
            platform: .iOS,
            product: .framework,
            deploymentTarget: DEPLOYMENT_TARGET,
            dependencies: [
                .package(product: ExternalDependencyName.realm),
                .package(product: ExternalDependencyName.realmSwift),
                .package(product: ExternalDependencyName.googleAPIClientForRESTCore),
                .package(product: ExternalDependencyName.googleAPIClientForREST_Drive),
                .package(product: ExternalDependencyName.googleSignIn),
                .external(name: ExternalDependencyName.rxSwift),
                .external(name: ExternalDependencyName.rxUtilityDynamic),
                .external(name: ExternalDependencyName.extendedUserDefaults),
                .external(name: ExternalDependencyName.extendedUserDefaultsRxExtension),
                .target(name: "Domain"),
                .target(name: "Utility"),
            ],
            hasUnitTests: true,
            additionalTestDependencies: [
                .external(name: ExternalDependencyName.rxBlocking),
            ],
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "Utility",
            platform: .iOS,
            product: .framework,
            deploymentTarget: DEPLOYMENT_TARGET,
            scripts: [
                // 공동 작업자의 githook path 자동 세팅을 위함
                .pre(
                    path: "Scripts/set_githooks_path.sh",
                    name: "Set githooks path",
                    basedOnDependencyAnalysis: false
                ),
            ],
            hasUnitTests: true,
            appendSchemeTo: &schemes
        )
        + Target.module(
            name: "Testing",
            platform: .iOS,
            product: .framework,
            deploymentTarget: DEPLOYMENT_TARGET,
            dependencies: [
                .target(name: "Domain"),
                .target(name: "DataDriver"),
                .target(name: "Utility"),
                .target(name: "iOSCore"),
                .external(name: ExternalDependencyName.rxSwift),
            ],
            appendSchemeTo: &disposedSchemes
        )
        + Target.module(
            name: "iOSCore",
            platform: .iOS,
            product: .framework,
            deploymentTarget: DEPLOYMENT_TARGET,
            resourceOptions: [.default, .common],
            dependencies: [
                .target(name: "Domain"),
                .target(name: "DataDriver"),
                .target(name: "Utility"),
                .external(name: ExternalDependencyName.rxSwift),
                .external(name: ExternalDependencyName.rxCocoa),
                .external(name: ExternalDependencyName.rxUtilityDynamic),
                .external(name: ExternalDependencyName.swinject),
                .external(name: ExternalDependencyName.snapKit),
                .external(name: ExternalDependencyName.sfSafeSymbols),
                .external(name: ExternalDependencyName.then),
                .external(name: ExternalDependencyName.toast),
                .external(name: ExternalDependencyName.reactorKit),
            ],
            hasUnitTests: true,
            additionalTestDependencies: [
                .target(name: "Testing"),
                .external(name: ExternalDependencyName.rxBlocking),
                .external(name: ExternalDependencyName.rxTest),
            ],
            appendSchemeTo: &schemes
        )
        + [
            Target.init(
                name: PROJECT_NAME,
                platform: .iOS,
                product: .app,
                bundleId: "\(BASIC_BUNDLE_ID)",
                deploymentTarget: DEPLOYMENT_TARGET,
                infoPlist: .file(path: "Resources/InfoPlist/Info.plist"),
                sources: "Sources/\(PROJECT_NAME)/**",
                resources: [
                    "Resources/Common/**",
                    "Resources/InfoPlist/Product/**",
                ],
                dependencies: [.target(name: "iOSCore")],
                settings: .settings()
            ),
            Target.init(
                name: "\(PROJECT_NAME)Dev",
                platform: .iOS,
                product: .app,
                bundleId: "\(BASIC_BUNDLE_ID)Dev",
                deploymentTarget: DEPLOYMENT_TARGET,
                infoPlist: .file(path: "Resources/InfoPlist/Info.plist"),
                sources: "Sources/\(PROJECT_NAME)Dev/**",
                resources: [
                    "Resources/Common/**",
                    "Resources/InfoPlist/Dev/**",
                ],
                dependencies: [
                    .target(name: "iOSCore"),
                    .target(name: "Testing"),
                ],
                settings: .settings()
            ),
            Target.init(
                name: "\(PROJECT_NAME)UITests",
                platform: .iOS,
                product: .uiTests,
                bundleId: "\(BASIC_BUNDLE_ID)UITests",
                deploymentTarget: DEPLOYMENT_TARGET,
                sources: "Tests/\(PROJECT_NAME)UITests/**",
                dependencies: [
                    .target(name: "\(PROJECT_NAME)Dev"),
                    .target(name: "iOSCore"),
                    .target(name: "Testing"),
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
    ],
    additionalFiles: [
        ".swiftlint.yml",
        "TestPlans/",
        "Scripts/",
        ".gitignore",
    ],
    resourceSynthesizers: []
)
