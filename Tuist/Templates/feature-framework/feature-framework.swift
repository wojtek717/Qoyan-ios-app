import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")
let template = Template(
    description: "Feature framework template",
    attributes: [
        nameAttribute,
        .optional("platform", default: "iOS"),
    ],
    files: [
        // Sources
        .file(
            path: "Qoyan/Feature/\(nameAttribute)/Project.swift",
            templatePath: "Stencils/feature_project.stencil"),
        // Tests
        .file(
            path: "Qoyan/Feature/\(nameAttribute)/Tests/\(nameAttribute)Tests.swift",
            templatePath: "Stencils/tests_contents.stencil"),
    ])
