#!/usr/bin/env swift

import Foundation

let workspace = "Pokedex.xcworkspace"
let scheme = "Pokedex-Workspace"
let device = "iPhone 15"
let osVersion = "17.2"
let testDataOutput = "output"
let platform = "iOS Simulator"

// MARK: XcodeCommandBuilder
//
// xcodebuild -workspace Pokedex.xcworkspace -scheme Pokedex -sdk iphonesimulator -destination "platform=iOS Simulator,name=iPhone 14,OS=16.2" test
struct XcodeCommandBuilder {
    static func buildTestCommand(workspace: String,
                          scheme: String,
                          platform: String,
                          device: String, 
                          osVersion: String
    ) -> String {
        "xcodebuild -workspace \(workspace) -scheme \(scheme) -sdk iphonesimulator -destination \"platform=\(platform),name=\(device),OS=\(osVersion)\" -enableCodeCoverage YES -quiet -resultBundlePath output/tests test"
    }
    
    static func buildDefaultTestCommand() -> String {
        buildTestCommand(workspace: workspace,
                         scheme: scheme,
                         platform: platform,
                         device: device,
                         osVersion: osVersion)
    }
}

print("Run unit testing targets for modules with changed sources")

let changedModules = findChangedModules()

if changedModules.count == 0 || changedModules.count == 1 && changedModules[0].isEmpty {
    print("Success. ".colored(.green) + "No changes found. Check that new sources have been added to Git.")
    
    let output = shell("git ls-files --others | grep Sources | grep swift")
    if !output.isEmpty {
        print("Untracked sources: ")
        print(output.colored(.red))
    }
    
    exit(0)
}

var targets = ""

for module in changedModules {
    targets += " \(module)Tests"
}

print("Move Workspace.swift to enable generating a focused project. ")
var output = shell("mv Workspace.swift Workspace_tmp.swift")

output = shell("tuist generate --no-open \(targets)")
print(output)

print("Clean tests data from the output directory. ")
output = shell("[ -d output/tests.xcresult ] && rm -r output/tests.xcresult || echo \"No test data to delete\"")
print(output)
output = shell("[ -L output/tests ] && rm output/tests || echo \"No tests link to delete\"")
print(output)

print(XcodeCommandBuilder.buildDefaultTestCommand())

output = shell(XcodeCommandBuilder.buildDefaultTestCommand())
print(output)

print("Move Workspace.swift back.")
output = shell("mv Workspace_tmp.swift Workspace.swift")
print(output)

output = shell("bash scripts/xccov_export_json_coverage_report.sh")
print(output)

output = shell("swift scripts/coverageQualityGate.swift output/xccov_coverage.json")
print(output)

func findChangedModules() -> [String] {
    let rawData = shell("bash ./scripts/filterModuleChanges.sh")
    let trimmedFeatures = rawData.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    return Array(Set(trimmedFeatures.components(separatedBy: " ")))
}

// MARK: - shell wrapper function
func shell(_ command: String) -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.launchPath = "/bin/zsh"
    task.standardInput = nil
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return output
}

enum ANSIColor: String {
    typealias This = ANSIColor
    
    case black = "\u{001B}[0;30m"
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case magenta = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
    case white = "\u{001B}[0;37m"
    case `default` = "\u{001B}[0;0m"
    
    static var values: [This] {
        return [.black, .red, .green, .yellow, .blue, .magenta, .cyan, .white, .default]
    }

    static func + (lhs: This, rhs: String) -> String {
        return lhs.rawValue + rhs
    }

    static func + (lhs: String, rhs: This) -> String {
        return lhs + rhs.rawValue
    }
}

extension String {
    func colored(_ color: ANSIColor) -> String {
        return color + self + ANSIColor.default
    }

    var black: String {
        return colored(.black)
    }

    var red: String {
        return colored(.red)
    }

    var green: String {
        return colored(.green)
    }

    var yellow: String {
        return colored(.yellow)
    }

    var blue: String {
        return colored(.blue)
    }

    var magenta: String {
        return colored(.magenta)
    }

    var cyan: String {
        return colored(.cyan)
    }

    var white: String {
        return colored(.white)
    }
}

