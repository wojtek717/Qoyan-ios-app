import ProjectDescription

// More info: https://tuist.io/docs/architectures/microfeatures/

public enum uFeatureTarget: CaseIterable {
    case framework
    case tests
    case testing
    
    public static var set: Set<uFeatureTarget> { Set(allCases) }
}

extension Project {
    public static func framework(name: String,
                                 product: Product = .framework,
                                 targets: Set<uFeatureTarget>,
                                 actions: [ProjectDescription.TargetAction] = [],
                                 packages: [Package] = [],
                                 externalDependencies: [TargetDependency] = [],
                                 featureDependencies: [String] = [],
                                 coreDependencies: [String] = [],
                                 testingDependencies: [String] = [],
                                 sdks: [String] = [],
                                 sources: [String] = [],
                                 resources: [ResourceFileElement] = [],
                                 testingResources: [ResourceFileElement] = [],
                                 headers: Headers? = nil,
                                 settings: SettingsDictionary = [:],
                                 withPublicResources: Bool = false,
                                 additionalPlistRows: [String: ProjectDescription.InfoPlist.Value] = [:]) -> Project {
        let configurations: [CustomConfiguration] = [
            .debug(
                name: "Debug",
                settings: SettingsDictionary()
                    .merging(settings)),
            .release(
                name: "Release",
                settings: SettingsDictionary()
                    .merging(settings)),
        ]
        
        let testsDependencies: [TargetDependency] = [
            .target(name: "\(name)Testing"),
            .xctest,
        ]
        
        // Target dependencies
        var targetDependencies: [TargetDependency] = []
        
        targetDependencies.append(contentsOf: externalDependencies)
        
        featureDependencies.forEach {
            targetDependencies.append(.project(target: $0, path: .relativeToRoot("Qoyan/Feature/\($0)")))
        }
        
        coreDependencies.forEach {
            targetDependencies.append(.project(target: $0, path: .relativeToRoot("Qoyan/Core/\($0)")))
        }
        
        targetDependencies.append(contentsOf: sdks.map { .sdk(name: $0) })
        
        var commonRows: [String: ProjectDescription.InfoPlist.Value] = [
            "CFBundleLocalizations": ["en"],
        ]
        commonRows = commonRows.merging(additionalPlistRows) { $1 }
        
        let testingDependecies = targetDependencies + testingDependencies.map {
            .project(target: $0, path: .relativeToRoot("Qoyan/Feature/\($0)"))
        }
        
        // Project targets
        var projectTargets: [Target] = []
        let frameworkSources = SourceFilesList(globs: sources + [
            "Sources/**/*.swift",
            "SupportingFiles/**/*.swift",
        ])
        
        if targets.contains(.framework) {
            projectTargets.append(Target(
                                    name: name,
                                    platform: .iOS,
                                    product: product,
                                    bundleId: "com.qoyan.\(name)",
                                    deploymentTarget: .iOS(targetVersion: "14.0", devices: [.iphone]),
                                    infoPlist: InfoPlist.extendingDefault(with: commonRows),
                                    sources: frameworkSources,
                                    resources: ResourceFileElements(resources: resources),
                                    headers: headers,
                                    actions: [
                                        .post(
                                            script: "tuist lint code \(name)", name: "Lint")
                                    ] + actions,
                                    dependencies: targetDependencies,
                                    settings: Settings(
                                        base: [
                                            "CODE_SIGN_IDENTITY": "",
                                            "CODE_SIGNING_REQUIRED": "NO",
                                            "CODE_SIGN_ENTITLEMENTS": "",
                                            "CODE_SIGNING_ALLOWED": "NO",
                                            "DEVELOPMENT_TEAM": "KKG46J7UE8",
                                        ],
                                        configurations: configurations,
                                        defaultSettings: .recommended)))
        }
        
        if targets.contains(.testing) {
            projectTargets.append(Target(
                                    name: "\(name)Testing",
                                    platform: .iOS,
                                    product: .framework,
                                    bundleId: "com.qoyan.\(name)Testing",
                                    infoPlist: .default,
                                    sources: SourceFilesList(globs: [
                                        SourceFileGlob("Testing/**")
                                    ]),
                                    resources: ResourceFileElements(resources: testingResources),
                                    actions: [],
                                    dependencies: testingDependecies + [.target(name: "\(name)")],
                                    settings: Settings(configurations: configurations,
                                                       defaultSettings: .recommended)))
        }
        
        if targets.contains(.tests) {
            projectTargets.append(Target(
                                    name: "\(name)Tests",
                                    platform: .iOS,
                                    product: .unitTests,
                                    bundleId: "com.qoyan.\(name)Tests",
                                    infoPlist: .default,
                                    sources: "Tests/**/*.swift",
                                    dependencies: targetDependencies + testsDependencies,
                                    settings: Settings(configurations: configurations,
                                                       defaultSettings: .recommended)))
        }
        
        // Project
        return Project(
            name: name,
            packages: packages,
            settings: Settings(configurations: configurations),
            targets: projectTargets)
    }
}
