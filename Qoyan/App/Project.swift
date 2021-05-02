import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Project

// Creates our project using a helper function defined in ProjectDescriptionHelpers

let iosTarget = Target(
    name: "Qoyan-iOS",
    platform: .iOS,
    product: .app,
    bundleId: "io.qoyan.app",
    infoPlist: .file(path: .relativeToCurrentFile("/Users/wojciechkonury/Desktop/App/Qoyan/App/Supporting Files/Info.plist")),
    sources: ["Sources/**"],
    resources: ["Resources/**"],
    dependencies: [
        /* Target dependencies can be defined here */
        /* .framework(path: "framework") */
    ]
)

let project = Project(
    name: "Qoyan",
    organizationName: "QoyanApp",
    targets: [iosTarget]
)
