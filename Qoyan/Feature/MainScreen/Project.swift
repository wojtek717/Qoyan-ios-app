import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "MainScreen",
    targets: uFeatureTarget.set,
    actions: [],
    packages: [],
    externalDependencies: [],
    featureDependencies: [],
    coreDependencies: [
        "Vendors"
    ],
    sdks: [],
    resources: [
        .glob(pattern: "**/*.xib"),
    ],
    additionalPlistRows: [:])

