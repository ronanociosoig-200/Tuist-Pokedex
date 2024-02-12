#!/usr/bin/env swift

import Foundation

let workspace = "Pokedex.xcworkspace"
let scheme = "Pokedex-Workspace"
let device = "iPhone 15"
let osVersion = "17.2"
let testDataOutput = "output"
let platform = "iOS Simulator"

let sanityUITestTarget = "PokedexUITests"

// MARK: XcodeCommandBuilder
//
// xcodebuild -workspace Pokedex.xcworkspace -scheme Pokedex -sdk iphonesimulator -destination "platform=iOS Simulator,name=iPhone 14,OS=16.2" test
struct XcodeUITestingCommandBuilder {
    static func buildTestCommand(workspace: String,
                                 scheme: String,
                                 platform: String,
                                 device: String,
                                 osVersion: String
    ) -> String {
        "xcodebuild -workspace \(workspace) -scheme \(scheme) -sdk iphonesimulator -destination \"platform=\(platform),name=\(device),OS=\(osVersion)\" -enableCodeCoverage NO -quiet test"
    }
    
    static func buildDefaultTestCommand() -> String {
        buildTestCommand(workspace: workspace,
                         scheme: scheme,
                         platform: platform,
                         device: device,
                         osVersion: osVersion)
    }
}

let changedModules = findChangedModules()
let requiredTestingTargets = testingTargets(changedModules: changedModules)
let command = "tuist generate " + requiredTestingTargets
print(command)
var output = shell(command)
print(output)
print(XcodeUITestingCommandBuilder.buildDefaultTestCommand())
output = shell(XcodeUITestingCommandBuilder.buildDefaultTestCommand())
print(output)

func testingTargets(changedModules: [String]) -> String {
    var targets = sanityUITestTarget
    let uiTestingTargets = findAllUITestingTargets()
    
    for module in changedModules {
        if module != "Pokedex" {
            let testingModule = module + "UITests"
            if uiTestingTargets.contains(testingModule) {
                targets += " \(testingModule)"
            }
        }
    }
    return targets
}

func findChangedModules() -> [String] {
    let rawData = shell("bash ./scripts/filterModuleChanges.sh")
    let trimmedFeatures = rawData.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    return Array(Set(trimmedFeatures.components(separatedBy: " ")))
}

func findAllUITestingTargets() -> [String] {
    var output = shell("tuist generate --no-open")
    output = shell("xcodebuild -list -project Pokedex.xcodeproj -json")
    let jsonData = output.data(using: .utf8)!
    guard let xcodeProject = try? JSONDecoder().decode(XcodeProject.self, from: jsonData) else {
        return []
    }
    
    return xcodeProject.project.targets.filter { $0.contains("UITests")
    }
}

// MARK: - XcodeProject
struct XcodeProject: Codable {
    let project: Project
}

// MARK: - Project
struct Project: Codable {
    let configurations: [String]
    let name: String
    let schemes, targets: [String]
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
