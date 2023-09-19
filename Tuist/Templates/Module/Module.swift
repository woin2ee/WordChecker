import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "Module template",
    attributes: [
        nameAttribute,
        .optional("platform", default: "ios"),
    ],
    items: [
        .file(
            path: "Sources/\(nameAttribute)/\(nameAttribute).swift",
            templatePath: .relativeToCurrentFile("../Source.stencil")
        ),
    ]
)
