import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "QoyanUI",
    targets: [.framework],
    featureDependencies: [],
    coreDependencies: [
        "Vendors"
    ],
    resources: [
        .glob(pattern: "**/*.xib"),
        .glob(pattern: "Resources/**"),
    ],
    withPublicResources: true)
