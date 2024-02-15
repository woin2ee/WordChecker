import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "Create default files for IOSScene.",
    attributes: [
        nameAttribute,
        .optional("platform", default: "ios"),
    ],
    items: [
        .file(
            path: "Sources/IOSScenes/\(nameAttribute)/\(nameAttribute)ViewController.swift",
            templatePath: .relativeToCurrentFile("../ViewController.stencil")
        ),
        .file(
            path: "Sources/IOSScenes/\(nameAttribute)/\(nameAttribute)Reactor.swift",
            templatePath: .relativeToCurrentFile("../Reactor.stencil")
        ),
        .file(
            path: "Sources/IOSScenes/\(nameAttribute)/\(nameAttribute)Assembly.swift",
            templatePath: .relativeToCurrentFile("../Assembly.stencil")
        ),
        .file(
            path: "Sources/IPhoneDriver/Coordinators/\(nameAttribute)Coordinator.swift",
            templatePath: .relativeToCurrentFile("../IPhoneCoordinator.stencil")
        ),
        .file(
            path: "Tests/IOSScenesTests/\(nameAttribute)Tests/\(nameAttribute)Tests.swift",
            templatePath: .relativeToCurrentFile("../UnitTests.stencil")
        ),
        .file(
            path: "TestPlans/\(nameAttribute).xctestplan",
            templatePath: .relativeToCurrentFile("../TestPlan.stencil")
        ),
    ]
)
