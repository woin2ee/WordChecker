// swift-tools-version: 5.9
import PackageDescription


#if TUIST
    import ProjectDescription
    import ProjectDescriptionHelpers


    let packageSettings = PackageSettings(
        productTypes: [
            :
        ]
    )
#endif


let package = Package(
    name: "PackageName",
    dependencies: [
        // RxSwift
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.6.0"),
        // Swinject
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0"),
        // SwinjectExtension
        .package(url: "https://github.com/Woin2ee-Modules/SwinjectExtension.git", from: "2.0.0"),
        // SnapKit
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.1"),
        // Realm
        .package(url: "https://github.com/realm/realm-swift.git", from: "10.42.0"),
        // RxSwiftSugar
        .package(url: "https://github.com/Woin2ee-Modules/RxSwiftSugar.git", from: "1.0.0"),
        // ExtendedUserDefaults
        .package(url: "https://github.com/Woin2ee-Modules/ExtendedUserDefaults.git", from: "1.0.0"),
        // SFSafeSymbols
        .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", from: "4.0.0"),
        // Then
        .package(url: "https://github.com/devxoul/Then", from: "3.0.0"),
        // Toast-Swift
        .package(url: "https://github.com/scalessec/Toast-Swift.git", from: "5.0.0"),
        // GoogleSignIn-iOS
        .package(url: "https://github.com/google/GoogleSignIn-iOS", from: "6.0.2"),
        // google-api-objectivec-client-for-rest
        .package(url: "https://github.com/google/google-api-objectivec-client-for-rest.git", from: "3.0.0"),
        // ReactorKit
        .package(url: "https://github.com/ReactorKit/ReactorKit.git", from: "3.0.0"),
        // FoundationPlus
        .package(url: "https://github.com/Woin2ee-Modules/FoundationPlus.git", from: "1.0.0"),
        // UIKitPlus
        .package(url: "https://github.com/Woin2ee-Modules/UIKitPlus.git", from: "1.0.0"),
        // swiftui-introspect
        .package(url: "https://github.com/siteline/swiftui-introspect", from: "1.0.0"),
        // PinLayout
        .package(url: "https://github.com/layoutBox/PinLayout", from: "1.0.0"),
        // Swift Collections
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.0"),
    ]
)
