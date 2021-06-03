import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Project

// Creates our project using a helper function defined in ProjectDescriptionHelpers

let iosTarget = Target(
    name: "Qoyan-iOS",
    platform: .iOS,
    product: .app,
    bundleId: "io.qoyan.app",
    infoPlist: .file(path: .relativeToCurrentFile("Supporting Files/Info.plist")),
    sources: ["Sources/**"],
    resources: ["Resources/**"],
    dependencies: [
        .project(
            target: "Vendors",
            path: .relativeToRoot("Qoyan/Core/Vendors")),
        .project(
            target: "MainScreen",
            path: .relativeToRoot("Qoyan/Feature/MainScreen")),
    ]
)

let project = Project(
    name: "Qoyan",
    organizationName: "QoyanApp",
    targets: [iosTarget]
)
