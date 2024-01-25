import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "Create default files for iOSScene.",
    attributes: [
        nameAttribute,
        .optional("platform", default: "ios"),
    ],
    items: [
        .file(
            path: "Sources/iOSScenes/\(nameAttribute)/\(nameAttribute)ViewController.swift",
            templatePath: .relativeToCurrentFile("../ViewController.stencil")
        ),
        .file(
            path: "Sources/iOSScenes/\(nameAttribute)/\(nameAttribute)Reactor.swift",
            templatePath: .relativeToCurrentFile("../Reactor.stencil")
        ),
        .file(
            path: "Sources/iOSScenes/\(nameAttribute)/\(nameAttribute)Assembly.swift",
            templatePath: .relativeToCurrentFile("../Assembly.stencil")
        ),
        .file(
            path: "Tests/iOSScenesTests/\(nameAttribute)Tests/\(nameAttribute)Tests.swift",
            templatePath: .relativeToCurrentFile("../UnitTests.stencil")
        ),
        .file(
            path: "TestPlans/\(nameAttribute).xctestplan",
            templatePath: .relativeToCurrentFile("../TestPlan.stencil")
        ),
    ]
)
