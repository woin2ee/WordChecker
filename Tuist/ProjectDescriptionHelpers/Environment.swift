import Foundation
import ProjectDescription

public struct WordCheckerEnvironment {
    public let organization = "woin2ee"
    public let projectName = "WordChecker"
    public let baseBundleID = "com.woin2ee.WordChecker"
    public let minimumIOSVersion = "17.0"
    public let minimumMacOSVersion = "14.0.0"
    public private(set) lazy var allDeploymentTargets = DeploymentTargets.multiplatform(
        iOS: minimumIOSVersion,
        macOS: minimumMacOSVersion
    )
    public let allDestinations = Destinations([.iPhone, .iPad, .mac])
}

public var env = WordCheckerEnvironment()
