import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
        .remote(url: "https://github.com/ronanociosoig/JGProgressHUD",
                requirement: .upToNextMajor(from: "2.0.0")),
        .remote(url: "https://github.com/pointfreeco/swift-snapshot-testing",
                requirement: .upToNextMinor(from: "1.10.0"))
    ],
    platforms: [.iOS]
)
