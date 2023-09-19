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
            path: "Tests/\(nameAttribute)/\(nameAttribute)Tests.swift",
            templatePath: .relativeToCurrentFile("../UnitTests.stencil")
        ),
    ]
)
