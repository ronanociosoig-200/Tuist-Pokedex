import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Project

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(name: "Pokedex", 
                          organizationName: "sonomos.com",
                          platform: .iOS,
                          externalDependencies: makeExternalDependencies(),
                          moduleTargets: makeAllCoreModules() + makeAllFeatures(),
                          testTargets: [.uiTests, .unitTests],
                          additionalTargets: [.widgetExtension])

func makeExternalDependencies() -> [String] {
    return ["JGProgressHUD", "SnapshotTesting"]
}

func makeAllFeatures() -> [Module] {
    return [makeHomeModule(),
            makeCatchModule(),
            makeBackpackModule(),
            makeDetailModule()]
}

func makeAllCoreModules() -> [Module] {
    return [makeCommonModule(),
            makeUIComponentsModule(),
            makeNetworkModule(),
            makeHanekeModule()]
}

func makeHomeModule() -> Module {
    return Module(name: "Home",
                  moduleType: .feature,
                  path: "Home",
                  frameworkDependancies: [.target(name: "Common")],
                  exampleDependencies: [.external(name: "JGProgressHUD")], testingDependencies: [.external(name: "SnapshotTesting")],
                  frameworkResources: ["Sources/**/*.storyboard", "Resources/**", "*.md"],
                  exampleResources: ["Resources/**"],
                  testResources: [],
                  targets: [.framework, .unitTests, .uiTests, .app]) // .snapshotTests,
}

func makeBackpackModule() -> Module {
    return Module(name: "Backpack",
                  moduleType: .feature,
           path: "Backpack",
           frameworkDependancies: [.target(name: "Common"),
            .target(name: "Haneke")],
                  exampleDependencies: [.target(name: "Detail")],
                  testingDependencies: [.external(name: "SnapshotTesting")],
           frameworkResources: ["Resources/**", "Sources/**/*.xib", "Sources/**/*.storyboard"],
           exampleResources: ["Resources/**", "Sources/**/*.storyboard"],
                  testResources: [],
                  targets: [.framework, .unitTests, .uiTests, .app]) // .snapshotTests,
}

func makeDetailModule() -> Module {
    return Module(name: "Detail",
                  moduleType: .feature,
                  path: "Detail",
                  frameworkDependancies: [.target(name: "Common"),
                                          .target(name: "UIComponents"),
                                          .target(name: "Haneke")],
                  exampleDependencies: [],
                  testingDependencies: [.external(name: "SnapshotTesting")],
                  frameworkResources: ["Sources/**/*.storyboard"],
                  exampleResources: ["Resources/**"],
                  testResources: [],
                  targets: [.framework, .unitTests, .uiTests, .app]) // .snapshotTests,
}

func makeCatchModule() -> Module {
    Module(name: "Catch",
           moduleType: .feature,
           path: "Catch",
           frameworkDependancies: [.target(name: "Common"),
                                   .target(name: "UIComponents"),
                                   .target(name: "Haneke")],
           exampleDependencies: [.external(name: "JGProgressHUD"),
                                 .target(name: "NetworkKit")],
           testingDependencies: [.external(name: "SnapshotTesting")],
           frameworkResources: ["Resources/**", "Sources/**/*.storyboard"],
           exampleResources: ["Resources/**", "Sources/**/*.storyboard"],
           testResources: [],
           targets: [.framework, .unitTests, .uiTests, .app]) // .snapshotTests,
}

func makeCommonModule() -> Module {
    return Module(name: "Common",
                  moduleType: .core,
                  path: "Common",
                  frameworkDependancies: [],
                  exampleDependencies: [],
                  testingDependencies: [],
                  frameworkResources: [],
                  exampleResources: ["Resources/**"],
                  testResources: [],
                  targets: [.framework, .unitTests])
}

func makeUIComponentsModule() -> Module {
    Module(name: "UIComponents",
           moduleType: .core,
           path: "UIComponents",
           frameworkDependancies: [],
           exampleDependencies: [.target(name: "Common")],
           testingDependencies: [.external(name: "SnapshotTesting")],
           frameworkResources: ["Sources/**/*.xib"],
           exampleResources: ["Resources/**"],
           testResources: [],
           targets: [.framework, .uiTests, .app])
}

func makeNetworkModule() -> Module {
    return Module(name: "NetworkKit",
                  moduleType: .core,
                  path: "Network",
                  frameworkDependancies: [],
                  exampleDependencies: [.target(name: "Common")],
                  testingDependencies: [],
                  frameworkResources: ["Resources/**"],
                  exampleResources: ["Resources/**"],
                  testResources: ["**/*.json"],
                  targets: [.framework, .unitTests, .app])
}

func makeHanekeModule() -> Module {
    return Module(name: "Haneke",
                  moduleType: .core,
                  path: "Haneke",
                  frameworkDependancies: [],
                  exampleDependencies: [],
                  testingDependencies: [],
                  frameworkResources: [],
                  exampleResources: ["Resources/**"],
                  testResources: [])
}
