import Danger
import DangerSwiftCoverage // package: https://github.com/f-meloni/danger-swift-coverage.git
import Foundation

private func fileExists(file: String) -> Bool { 
    FileManager.default.fileExists(atPath: file)
}

print("Checking test coverage...")

let fileManager = FileManager.default
if fileExists(file: "output/tests/unit/ios-whitelabel-UnitTests.xcresult") {
    // Unitests
    Coverage.xcodeBuildCoverage(.xcresultBundle("output/tests/unit/ios-whitelabel-UnitTests.xcresult"), minimumCoverage: 80, excludedTargets: [
        .regex(".*Unit-Tests[^/]+"), 
        .regex(".*Mocks*[^/]+"),
        .regex(".*SnapshotTests*[^/]+"),
        .regex(".*Tests*[^/]+")
    ])
} else if fileExists(file: "output/tests/unit/ios-whitelabel-AllTests.xcresult") {
    // AllTests
    Coverage.xcodeBuildCoverage(.xcresultBundle("output/tests/unit/ios-whitelabel-AllTests.xcresult"), minimumCoverage: 80, excludedTargets: [
        .regex(".*Unit-Tests[^/]+"), 
        .regex(".*Mocks*[^/]+"),
        .regex(".*SnapshotTests*[^/]+"),
        .regex(".*Tests*[^/]+")
    ])
} else {
    message("Cannot find code coverage report.")
}