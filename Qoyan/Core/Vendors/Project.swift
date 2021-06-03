import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "Vendors",
    targets: uFeatureTarget.set,
    actions: [],
    packages: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.18.0")
    ],
    externalDependencies: [
    .package(product: "ComposableArchitecture")
],
    featureDependencies: [],
    sdks: [],
    resources: [
        .glob(pattern: "**/*.xib"),
    ],
    additionalPlistRows: [:])

