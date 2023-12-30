//  swift-tools-version: 5.9
import ProjectDescription

let package = Package(
    name: "Tuist-Pokedex",
    dependencies: [
        .package(url: "https://github.com/ronanociosoig/JGProgressHUD", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", .upToNextMinor(from: "1.10.0"))
    ]
)

//.package(url: "https://github.com/ronanociosoig/JGProgressHUD",
//        requirement: .upToNextMajor(from: "2.0.0")),
//.package(url: "https://github.com/pointfreeco/swift-snapshot-testing",
//        requirement: .upToNextMinor(from: "1.10.0"))
