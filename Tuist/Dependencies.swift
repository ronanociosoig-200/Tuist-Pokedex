import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
        .remote(url: "https://github.com/ronanociosoig/JGProgressHUD", requirement: .upToNextMajor(from: "2.0.0"))
    ],
    platforms: [.iOS]
)
