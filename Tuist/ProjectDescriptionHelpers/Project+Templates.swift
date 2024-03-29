import ProjectDescription

let reverseOrganizationName = "com.sonomos"

let featuresPath = "Features"
let corePath = "Core"
let appPath = "App"
let microAppSuffix = "App"
let microAppPath = "App"
let watchAppPath = "WatchApp"
let widgetAppPath = "WidgetApp"

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://tuist.io/docs/usage/helpers/

public enum uFeatureTarget {
    case framework
    case unitTests
    case snapshotTests
    case uiTests
    case app
}

public enum TestTarget {
    case unitTests
    case snapshotTests
    case uiTests
}

public enum AdditionalTarget {
    case watchApp
    case widgetExtension
}

public enum ModuleType {
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
    let moduleType: ModuleType
    
    public init(name: String,
                moduleType: ModuleType,
                path: String,
                frameworkDependancies: [TargetDependency],
                exampleDependencies: [TargetDependency],
                testingDependencies: [TargetDependency],
                frameworkResources: [String],
                exampleResources: [String],
                testResources: [String],
                targets: Set<uFeatureTarget> = Set([.framework, .unitTests, .app])) {
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
                           organizationName: String,
                           platform: Platform,
                           externalDependencies: [String],
                           targetDependancies: [TargetDependency] = [],
                           moduleTargets: [Module],
                           testTargets: Set<TestTarget> = Set([.unitTests, .snapshotTests, .uiTests]),
                           additionalTargets: Set<AdditionalTarget> = Set([])) -> Project {
        
        let organizationName = organizationName
        var targets = [Target]()
        var dependencies = moduleTargets.map { TargetDependency.target(name: $0.name) }
        dependencies.append(contentsOf: targetDependancies)
        
        let externalTargetDependencies = externalDependencies.map {
            TargetDependency.external(name: $0)
        }
        
        dependencies.append(contentsOf: externalTargetDependencies)
        
        if additionalTargets.contains(.widgetExtension) {
            let widgetExtensionTarget = makeWidgetExtension(name: name)
            let widgetExtensionTargetDependency = TargetDependency.target(name: widgetExtensionTarget.name)
            
            dependencies.append(widgetExtensionTargetDependency)
            targets.append(widgetExtensionTarget)
        }
        
        if additionalTargets.contains(.watchApp) {
            let watchAppTarget = makeWatchApp(name: name)
            let watchAppTargetDependency = TargetDependency.target(name: watchAppTarget.name)
            
            dependencies.append(watchAppTargetDependency)
            targets.append(watchAppTarget)
        }
        
        targets.append(contentsOf: makeAppTargets(name: name,
                                    platform: platform,
                                    dependencies: dependencies,
                                testTargets: testTargets))
                 
        targets += moduleTargets.flatMap({ makeFrameworkTargets(module: $0, platform: platform) })
        
        /// These schemes were previously used for testing specific UI test cases but not needed now.
        // let schemes = makeSchemes(targetName: name)
        
        /// Add custom schemes with code coverage enabled
        // schemes += moduleTargets.flatMap({ makeSchemeWithCodeCoverage(targetName: $0.name) })
        
        let automaticSchemesOptions = Options.AutomaticSchemesOptions.enabled(
            targetSchemesGrouping: .byNameSuffix(build: ["Implementation",
                                                         "Interface",
                                                         "Mocks",
                                                         "Testing"],
                                                 test: ["Tests",
                                                        "IntegrationTests",
                                                        "UITests",
                                                        "SnapshotTests"],
                                                 run: ["App", "Example"]),
            codeCoverageEnabled: true,
            testingOptions: []
        )

      let options = Project.Options.options(automaticSchemesOptions: automaticSchemesOptions,
                                              developmentRegion: nil,
                                              disableBundleAccessors: false,
                                              disableShowEnvironmentVarsInScriptPhases: false,
                                              disableSynthesizedResourceAccessors: false,
                                              textSettings: Options.TextSettings.textSettings(),
                                              xcodeProjectName: nil)
        
        return Project(name: name,
                       organizationName: organizationName,
                       options: options,
                       targets: targets,
                       schemes: [],
        additionalFiles: ["*.md"],
        resourceSynthesizers: [])
    }
    
    public static func makeWidgetExtension(name: String) -> Target {
        return Target(
            name: "\(name)WidgetExtension",
            platform: .iOS,
            product: .appExtension,
            bundleId: "\(reverseOrganizationName).\(name).WidgetExtension",
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "$(PRODUCT_NAME)",
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.widgetkit-extension",
                ],
            ]),
            sources: "WidgetApp/Pokedex/Sources/**",
            resources: "WidgetApp/Pokedex/Resources/**",
            dependencies: []
        )
    }
    
    public static func makeWatchApp(name: String) -> Target {
        return Target(
            name: "\(name)WatchApp",
            platform: .watchOS,
            product: .app,
            bundleId: "\(reverseOrganizationName).\(name).watchkitapp",
            infoPlist: nil,
            sources: "WatchApp/Pokedex/Sources/**",
            resources: "WatchApp/Pokedex/Resources/**",
            dependencies: [],
            settings: .settings(
                            base: [
                                "GENERATE_INFOPLIST_FILE": true,
                                "CURRENT_PROJECT_VERSION": "1.0",
                                "MARKETING_VERSION": "1.0",
                                "INFOPLIST_KEY_UISupportedInterfaceOrientations": [
                                    "UIInterfaceOrientationPortrait",
                                    "UIInterfaceOrientationPortraitUpsideDown",
                                ],
                                "INFOPLIST_KEY_WKCompanionAppBundleIdentifier": "\(reverseOrganizationName).\(name)",
                                "INFOPLIST_KEY_WKRunsIndependentlyOfCompanionApp": false,
                            ]
                        )
        )
    }
    
    public static func makeAppInfoPlist() -> InfoPlist {
        let infoPlist: [String: Plist.Value] = [
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
            ResourceFileElement.glob(pattern: Path("\(module.moduleType.path())/\(module.path)/\(microAppPath)/" + $0), tags: [])
        }
        
        let testResourceFilePaths = module.testResources.map {
            ResourceFileElement.glob(pattern: Path("\(module.moduleType.path())/\(module.path)/Tests/" + $0), tags: [])
        }
        
        var exampleAppDependancies = module.exampleDependencies
        exampleAppDependancies.append(.target(name: module.name))
        
        let exampleSourcesPath = "\(module.moduleType.path())/\(module.path)/\(microAppPath)/Sources"
        
        var targets = [Target]()
        
        let microAppName = "\(module.name)\(microAppSuffix)"
        
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

        if module.targets.contains(.app) {
            targets.append(Target(name: microAppName,
                                  platform: platform,
                                  product: .app,
                                  bundleId: "\(reverseOrganizationName).\(module.name)\(microAppSuffix)",
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
                                  dependencies: [.target(name: microAppName)]))
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
                                      dependencies: [TargetDependency],
                                      testTargets: Set<TestTarget>) -> [Target] {
        var targets = [Target]()
        
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
        
        targets.append(mainTarget)
        
        if testTargets.contains(.unitTests) {
            let target = Target(
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
            targets.append(target)
        }
        
        if testTargets.contains(.snapshotTests) {
            let target = Target(
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
            targets.append(target)
        }

        if testTargets.contains(.uiTests) {
            let target = Target(
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
            targets.append(target)
        }
        return targets
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
