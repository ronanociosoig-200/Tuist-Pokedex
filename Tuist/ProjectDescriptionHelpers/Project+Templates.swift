import ProjectDescription

let reverseOrganizationName = "com.sonomos"

let featuresPath = "Features"
let corePath = "Core"
let appPath = "App"
let exampleAppSuffix = "Example"
let examplePath = "Example"

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://tuist.io/docs/usage/helpers/

public enum uFeatureTarget {
    case framework
    case unitTests
    case snapshotTests
    case uiTests
    case exampleApp
}

public enum AppModuleType {
    case core
    case feature
    case app

    func path() -> String {
        switch self {
        case .core:
            return corePath
        case .feature:
            return featuresPath
        case .app:
            return appPath
        }
    }
}

public struct Module {
    let name: String
    let path: String
    let frameworkDependancies: [TargetDependency]
    let exampleDependencies: [TargetDependency]
    let testingDependencies: [TargetDependency]
    let frameworkResources: [String]
    let exampleResources: [String]
    let testResources: [String]
    let targets: Set<uFeatureTarget>
    let moduleType: AppModuleType
    
    public init(name: String,
                moduleType: AppModuleType,
                path: String,
                frameworkDependancies: [TargetDependency],
                exampleDependencies: [TargetDependency],
                testingDependencies: [TargetDependency],
                frameworkResources: [String],
                exampleResources: [String],
                testResources: [String],
                targets: Set<uFeatureTarget> = Set([.framework, .unitTests, .exampleApp])) {
        self.name = name
        self.moduleType = moduleType
        self.path = path
        self.frameworkDependancies = frameworkDependancies
        self.exampleDependencies = exampleDependencies
        self.testingDependencies = testingDependencies
        self.frameworkResources = frameworkResources
        self.exampleResources = exampleResources
        self.testResources = testResources
        self.targets = targets
    }
}

extension Project {
    /// Helper function to create the Project for this ExampleApp
    public static func app(name: String,
                           platform: Platform,
                           externalDependencies: [String],
                           targetDependancies: [TargetDependency],
                           moduleTargets: [Module]) -> Project {
        
        let organizationName = "Sonomos.com"
        var dependencies = moduleTargets.map { TargetDependency.target(name: $0.name) }
        dependencies.append(contentsOf: targetDependancies)
        
        let externalTargetDependencies = externalDependencies.map {
            TargetDependency.external(name: $0)
        }
        
        dependencies.append(contentsOf: externalTargetDependencies)
        
        var targets = makeAppTargets(name: name,
                                     platform: platform,
                                     dependencies: dependencies)
        
        targets += moduleTargets.flatMap({ makeFrameworkTargets(module: $0, platform: platform) })
        
        /// These schemes were previously used for testing specific UI test cases but not needed now.
        // let schemes = makeSchemes(targetName: name)
        
        /// Add custom schemes with code coverage enabled
        // schemes += moduleTargets.flatMap({ makeSchemeWithCodeCoverage(targetName: $0.name) })
        
//        let automaticSchemesOptions = Options.AutomaticSchemesOptions.enabled(
//            targetSchemesGrouping: .byNameSuffix(build: ["Implementation",
//                                                         "Interface",
//                                                         "Mocks",
//                                                         "Testing"],
//                                                 test: ["Tests",
//                                                        "IntegrationTests",
//                                                        "UITests",
//                                                        "SnapshotTests"],
//                                                 run: ["App", "Example"]),
//            codeCoverageEnabled: true,
//            testingOptions: []
//        )
//
//      let options = Project.Options.options(automaticSchemesOptions: automaticSchemesOptions,
//                                              developmentRegion: nil,
//                                              disableBundleAccessors: false,
//                                              disableShowEnvironmentVarsInScriptPhases: false,
//                                              disableSynthesizedResourceAccessors: false,
//                                              textSettings: Options.TextSettings.textSettings(),
//                                              xcodeProjectName: nil)

        // options: options,
        return Project(name: name,
                       organizationName: organizationName,
                       targets: targets,
                       schemes: [],
        additionalFiles: ["*.md"])
    }
    
    public static func makeAppInfoPlist() -> InfoPlist {
        let infoPlist: [String: InfoPlist.Value] = [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen"
        ]
        
        return InfoPlist.extendingDefault(with: infoPlist)
    }
    
    /// Helper function to create a framework target and an associated unit test target and example app
    public static func makeFrameworkTargets(module: Module, platform: Platform) -> [Target] {
        let frameworkPath = "\(module.moduleType.path())/\(module.path)"
        
        let frameworkResourceFilePaths = module.frameworkResources.map {
            ResourceFileElement.glob(pattern: Path("\(module.moduleType.path())/\(module.path)/" + $0), tags: [])
        }
        
        let exampleResourceFilePaths = module.exampleResources.map {
            ResourceFileElement.glob(pattern: Path("\(module.moduleType.path())/\(module.path)/\(examplePath)/" + $0), tags: [])
        }
        
        let testResourceFilePaths = module.testResources.map {
            ResourceFileElement.glob(pattern: Path("\(module.moduleType.path())/\(module.path)/Tests/" + $0), tags: [])
        }
        
        var exampleAppDependancies = module.exampleDependencies
        exampleAppDependancies.append(.target(name: module.name))
        
        let exampleSourcesPath = "\(module.moduleType.path())/\(module.path)/\(examplePath)/Sources"
        
        var targets = [Target]()
        
        let exampleAppName = "\(module.name)\(exampleAppSuffix)"
        
        if module.targets.contains(.framework) {
            let headers = Headers.headers(public: ["\(frameworkPath)/Sources/**/*.h"])
            
            targets.append(Target(name: module.name,
                                  platform: platform,
                                  product: .framework,
                                  bundleId: "\(reverseOrganizationName).\(module.name)",
                                  infoPlist: .default,
                                  sources: ["\(frameworkPath)/Sources/**"],
                                  resources: ResourceFileElements(resources: frameworkResourceFilePaths),
                                  headers: headers,
                                  dependencies: module.frameworkDependancies))
        }

        if module.targets.contains(.unitTests) {
            targets.append(Target(name: "\(module.name)Tests",
                                  platform: platform,
                                  product: .unitTests,
                                  bundleId: "\(reverseOrganizationName).\(module.name)Tests",
                                  infoPlist: .default,
                                  sources: ["\(frameworkPath)/Tests/**"],
                                  resources: ResourceFileElements(resources: testResourceFilePaths),
                                  dependencies: [.target(name: module.name)]))
        }

        if module.targets.contains(.exampleApp) {
            targets.append(Target(name: exampleAppName,
                                  platform: platform,
                                  product: .app,
                                  bundleId: "\(reverseOrganizationName).\(module.name)\(exampleAppSuffix)",
                                  infoPlist: makeAppInfoPlist(),
                                  sources: ["\(exampleSourcesPath)/**"],
                                  resources: ResourceFileElements(resources: exampleResourceFilePaths),
                                  dependencies: exampleAppDependancies))
        }

        if module.targets.contains(.uiTests) {
            targets.append(Target(name: "\(module.name)UITests",
                                  platform: platform,
                                  product: .uiTests,
                                  bundleId: "\(reverseOrganizationName).\(module.name)UITests",
                                  infoPlist: .default,
                                  sources: ["\(frameworkPath)/UITests/**"],
                                  resources: ResourceFileElements(resources: testResourceFilePaths),
                                  dependencies: [.target(name: exampleAppName)]))
        }

        if module.targets.contains(.snapshotTests) {
            var dependencies = module.testingDependencies
            dependencies.append(.target(name: module.name))
            targets.append(Target(name: "\(module.name)SnapshotTests",
                                  platform: platform,
                                  product: .unitTests,
                                  bundleId: "\(reverseOrganizationName).\(module.name)SnapshotTests",
                                  infoPlist: .default,
                                  sources: ["\(frameworkPath)/SnapshotTests/**"],
                                  resources: ResourceFileElements(resources: testResourceFilePaths),
                                  dependencies: dependencies))
        }
        
        return targets
    }
    
    /// Helper function to create the application target and the unit test target.
    public static func makeAppTargets(name: String,
                                      platform: Platform,
                                      dependencies: [TargetDependency]) -> [Target] {
        
        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "\(reverseOrganizationName).\(name)",
            infoPlist: makeAppInfoPlist(),
            sources: ["\(appPath)/\(name)/Sources/**"],
            resources: ["\(appPath)/\(name)/Resources/**",
                        "\(appPath)/\(name)/*.md"
                       ],
            scripts: [
            ],
            dependencies: dependencies
        )
        
        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "\(reverseOrganizationName).\(name)Tests",
            infoPlist: .default,
            sources: ["\(appPath)/\(name)/Tests/**"],
            resources: ["\(appPath)/\(name)/Tests/**/*.json",
                        "\(appPath)/\(name)/Tests/**/*.png"],
            dependencies: [
                .target(name: "\(name)")
            ])
        
        let snapshotTestsTarget = Target(
            name: "\(name)SnapshotTests",
            platform: platform,
            product: .unitTests,
            bundleId: "\(reverseOrganizationName).\(name)SnapshotTests",
            infoPlist: .default,
            sources: ["\(appPath)/\(name)/SnapshotTests/**"],
            resources: [],
            dependencies: [
                .target(name: "\(name)")
            ])

        let uiTestTarget = Target(
            name: "\(name)UITests",
            platform: platform,
            product: .uiTests,
            bundleId: "\(reverseOrganizationName).\(name)UITests",
            infoPlist: .default,
            sources: ["\(appPath)/\(name)/UITests/**"],
            resources: [],
            dependencies: [
                .target(name: "\(name)")
            ])
        
        return [mainTarget, testTarget, snapshotTestsTarget, uiTestTarget]
    }
    
    public static func makeSchemes(targetName: String) -> [Scheme] {
        let mainTargetReference = TargetReference(stringLiteral: targetName)
        let debugConfiguration = ConfigurationName(stringLiteral: "Debug")
        let buildAction = BuildAction(targets: [mainTargetReference])
        let executable = mainTargetReference
        let asyncTestingLaunchArguments = Arguments(launchArguments: [LaunchArgument(name: "AsyncTesting", isEnabled: true)])
        let uiTestingLaunchArguments = Arguments(launchArguments: [LaunchArgument(name: "UITesting", isEnabled: true)])

        let target = TestableTarget(stringLiteral: "\(targetName)UITests")
        let testAction =
        TestAction.targets([target],
                           arguments: nil,
                           configuration: debugConfiguration,
                           attachDebugger: false,
                           expandVariableFromTarget: nil,
                           preActions: [],
                           postActions: [],
                           options: TestActionOptions.options(),
                           diagnosticsOptions: [])

        let runActionOptions = RunActionOptions.options(language: nil,
                                                        storeKitConfigurationPath: nil, simulatedLocation: nil)
        let asyncRunAction = RunAction.runAction(configuration: debugConfiguration,
                                                 attachDebugger: false,
                                                 preActions: [],
                                                 postActions: [],
                                                 executable: executable,
                                                 arguments: asyncTestingLaunchArguments,
                                                 options: runActionOptions,
                                                 diagnosticsOptions: [])

        let asyncTestingScheme = Scheme(
            name: "\(targetName)AsyncNetworkTesting",
            shared: false,
            buildAction: buildAction,
            runAction: asyncRunAction)

        let uiTestRunAction = RunAction.runAction(configuration: debugConfiguration,
                                                  attachDebugger: false,
                                                  preActions: [],
                                                  postActions: [],
                                                  executable: executable,
                                                  arguments: uiTestingLaunchArguments,
                                                  options: runActionOptions,
                                                  diagnosticsOptions: [])

        let uiTestingScheme = Scheme(
            name: "\(targetName)UITesting",
            shared: false,
            buildAction: buildAction,
            testAction: testAction,
            runAction: uiTestRunAction)

        return [asyncTestingScheme, uiTestingScheme]
    }
    
    public static func makeSchemeWithCodeCoverage(targetName: String) -> [Scheme] {
        let mainTargetReference = TargetReference(stringLiteral: targetName)
        let debugConfiguration = ConfigurationName(stringLiteral: "Debug")
        let buildAction = BuildAction(targets: [mainTargetReference])
        let executable = mainTargetReference
        let launchArguments = Arguments(launchArguments: [LaunchArgument(name: "Testing", isEnabled: true)])
        
        let target = TestableTarget(stringLiteral: "\(targetName)Tests")
        let testActionOptions = TestActionOptions.options(language: SchemeLanguage.init(stringLiteral: "en-US"),
                                                          region: "en-US",
                                                          coverage: true,
                                                          codeCoverageTargets: [])
        
        let testAction =
        TestAction.targets([target],
                           arguments: nil,
                           configuration: debugConfiguration,
                           attachDebugger: false,
                           expandVariableFromTarget: nil,
                           preActions: [],
                           postActions: [],
                           options: testActionOptions,
                           diagnosticsOptions: [])
        
        let runActionOptions = RunActionOptions.options(language: nil,
                                                        storeKitConfigurationPath: nil, simulatedLocation: nil)
        
        let runAction = RunAction.runAction(configuration: debugConfiguration,
                                            attachDebugger: false,
                                            preActions: [],
                                            postActions: [],
                                            executable: executable,
                                            arguments: launchArguments,
                                            options: runActionOptions,
                                            diagnosticsOptions: [])
        
        let testingScheme = Scheme(
            name: "\(targetName)WithCodeCoverage",
            shared: false,
            buildAction: buildAction,
            testAction: testAction,
            runAction: runAction)
        
        return [testingScheme]
    }
}
