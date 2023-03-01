// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Dangerfile",
    defaultLocalization: "en",
    platforms: [.macOS(.v12), .iOS(.v14)],
    products: [
        .library(
            name: "DangerDepsProduct",
            type: .dynamic,
            targets: ["DangerDependencies"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/danger/swift.git", from: "3.15.0"),
        .package(url: "https://github.com/f-meloni/danger-swift-coverage.git", from: "1.2.1"),
        .package(url: "https://github.com/f-meloni/danger-swift-xcodesummary.git", from: "1.2.1"),
        .package(url: "https://github.com/yumemi-inc/danger-swift-kantoku.git", from: "0.1.1"),
        .package(url: "https://github.com/shibapm/Komondor.git", branch: "1.1.3")
    ],
    targets: [
        .target(
            name: "DangerDependencies",
            dependencies: [
                .product(name: "Danger", package: "swift"),
                .product(name: "DangerSwiftCoverage", package: "danger-swift-coverage"),
                .product(name: "DangerXCodeSummary", package: "danger-swift-xcodesummary"),
                .product(name: "DangerSwiftKantoku", package: "danger-swift-kantoku")
            ],
            path: "Sources/DangerDependencies/",
            sources: ["Fake.swift"]
        )
    ]
)

#if canImport(PackageConfig)
import PackageConfig

let config = PackageConfiguration([
    "komondor": [
        "pre-commit": [
            "sh lint.sh",
            "git add ."
        ],
        "prepare-commit-msg": [],
        "commit-msg": [],
        "post-commit": [],
        "pre-push": [],
        "pre-rebase": [],
        "post-checkout": [],
        "post-rewrite": [],
        "post-merge": []
    ]
]).write()
#endif