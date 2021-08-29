import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Project

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(name: "Pokedex",
                          platform: .iOS,
                          packages: [
                            .package(url: "https://github.com/Moya/Moya.git", .exact("14.0.0")),
                            .package(url: "https://github.com/antitypical/Result.git", from: "5.0.0"),
                            .package(url: "https://github.com/JonasGessner/JGProgressHUD", .upToNextMajor(from: "2.0.0"))
                          ],
                          targetDependancies: [
                            .package(product: "JGProgressHUD")],
                          moduleTargets: [Module(name: "Haneke",
                                                             path: "Haneke",
                                                             frameworkDependancies: [],
                                                             exampleDependencies: [],
                                                             frameworkResources: [],
                                                             exampleResources: ["Resources/**"]),
                                              Module(name: "HomeUI",
                                                             path: "Home",
                                                             frameworkDependancies: [.target(name: "Common")],
                                                             exampleDependencies: [.package(product: "JGProgressHUD")],
                                                             frameworkResources: ["Sources/**/*.storyboard",
                                                                         "Resources/**"],
                                                             exampleResources: ["Resources/**"]),
                                              Module(name: "BackpackUI",
                                                             path: "Backpack",
                                                             frameworkDependancies: [.target(name: "Common"),
                                                                                     .target(name: "Haneke")],
                                                             exampleDependencies: [],
                                                             frameworkResources: ["Sources/**/*.xib",
                                                                         "Sources/**/*.storyboard"],
                                                             exampleResources: ["Resources/**",
                                                                                "Sources/**/*.storyboard"]),
                                              Module(name: "CatchUI",
                                                             path: "Catch",
                                                             frameworkDependancies: [.target(name: "Common"),
                                                                                     .target(name: "Haneke")],
                                                             exampleDependencies: [.package(product: "JGProgressHUD"),
                                                                                   .target(name: "NetworkKit")],
                                                             frameworkResources: ["Resources/**",
                                                                                  "Sources/**/*.storyboard"],
                                                             exampleResources: ["Resources/**",
                                                                                "Sources/**/*.storyboard"]),
                                              Module(name: "Common",
                                                             path: "Common",
                                                             frameworkDependancies: [],
                                                             exampleDependencies: [],
                                                             frameworkResources: ["Sources/**/*.xib"],
                                                             exampleResources: ["Resources/**"]),
                                              Module(name: "NetworkKit",
                                                             path: "Network",
                                                             frameworkDependancies: [
                                                                .package(product: "Moya"),
                                                                .package(product: "Result")
                                                             ],
                                                             exampleDependencies: [.target(name: "Common")],
                                                             frameworkResources: ["Resources/**"],
                                                             exampleResources: ["Resources/**"])
                          ])
