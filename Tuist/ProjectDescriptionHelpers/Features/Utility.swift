import ExternalDependencyPlugin
import MicroFeaturePlugin
import ProjectDescription

public let utilityFeature = FeatureManifest(
    baseName: "Utility",
    baseBundleID: env.baseBundleID,
    destinations: env.allDestinations,
    sourceProduct: .framework,
    deploymentTargets: env.allDeploymentTargets,
    scripts: [
        // 공동 작업자의 githook path 자동 세팅을 위함
        .pre(
            path: "Scripts/set_githooks_path.sh",
            name: "Set githooks path",
            basedOnDependencyAnalysis: false
        ),
    ],
    adoptedModules: [.source, .unitTests]
)
