// swift-tools-version:5.9
import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
    swiftPackageManager: .init(
        projectOptions: [
            "LocalSwiftPackage": .options(disableSynthesizedResourceAccessors: true),
        ]
    ),
    platforms: [.iOS] 
)
