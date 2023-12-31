import ProjectDescription

let dependencies = Dependencies(
    carthage: [
    ],
    swiftPackageManager: [
        // RxSwift
        .remote(url: "https://github.com/ReactiveX/RxSwift.git",
                requirement: .upToNextMajor(from: "6.6.0")),
        // Swinject
        .remote(url: "https://github.com/Swinject/Swinject.git",
                requirement: .upToNextMajor(from: "2.8.0")),
        // SwinjectExtension
        .remote(url: "https://github.com/Woin2ee-Modules/SwinjectExtension.git",
                requirement: .upToNextMajor(from: "2.0.0")),
        // SnapKit
        .remote(url: "https://github.com/SnapKit/SnapKit.git",
                requirement: .upToNextMajor(from: "5.0.1")),
        // Realm
        .remote(url: "https://github.com/realm/realm-swift.git",
                requirement: .upToNextMajor(from: "10.42.0")),
        // RxUtility
        .remote(url: "https://github.com/Woin2ee-Modules/RxUtility.git",
                requirement: .upToNextMajor(from: "1.0.0")),
        // ExtendedUserDefaults
        .remote(url: "https://github.com/Woin2ee-Modules/ExtendedUserDefaults.git",
                requirement: .upToNextMajor(from: "1.0.0")),
        // SFSafeSymbols
        .remote(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git",
                requirement: .upToNextMajor(from: "4.0.0")),
        // Then
        .remote(url: "https://github.com/devxoul/Then",
                requirement: .upToNextMajor(from: "3.0.0")),
        // Toast-Swift
        .remote(url: "https://github.com/scalessec/Toast-Swift.git",
                requirement: .upToNextMajor(from: "5.0.0")),
        // GoogleSignIn-iOS
        .remote(url: "https://github.com/google/GoogleSignIn-iOS",
                requirement: .upToNextMajor(from: "6.0.2")),
        // google-api-objectivec-client-for-rest
        .remote(url: "https://github.com/google/google-api-objectivec-client-for-rest.git",
                requirement: .upToNextMajor(from: "3.0.0")),
        // ReactorKit
        .remote(url: "https://github.com/ReactorKit/ReactorKit.git",
                requirement: .upToNextMajor(from: "3.0.0")),
    ],
    platforms: [.iOS]
)
