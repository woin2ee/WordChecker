import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "Module with tests template",
    attributes: [
        nameAttribute,
        .optional("platform", default: "ios"),
    ],
    items: [
        .file(
            path: "Sources/\(nameAttribute)/\(nameAttribute).swift",
            templatePath: .relativeToCurrentFile("../Source.stencil")
        ),
        .file(
            path: "Tests/\(nameAttribute)Tests/\(nameAttribute)Tests.swift",
            templatePath: .relativeToCurrentFile("../UnitTests.stencil")
        ),
        .file(
            path: "TestPlans/\(nameAttribute).xctestplan",
            templatePath: .relativeToCurrentFile("../TestPlan.stencil")
        ),
    ]
)
