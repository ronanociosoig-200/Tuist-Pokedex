#!/usr/bin/env swift

import Foundation

struct CoverageReport: Codable {
    let lines: Int
    let coverage: Double
    let targets: [Target]
    
    private enum CodingKeys: String, CodingKey {
        case lines = "coveredLines"
        case coverage = "lineCoverage"
        case targets = "targets"
    }
}

struct Target: Codable {
    let name: String
    let lines: Int
    let coverage: Double
    
    private enum CodingKeys: String, CodingKey {
        case lines = "coveredLines"
        case coverage = "lineCoverage"
        case name = "name"
    }
}

let arguments = CommandLine.arguments

guard arguments.count == 2 else {
    print("Incorrect parameters. Include JSON file generated by \"xcrun xccov view --report --json <tests.xcresult> \"")
    print("Usage: <script> file.json")
    exit(1)
}

let file = CommandLine.arguments[1]
let currentDirectoryPath = FileManager.default.currentDirectoryPath
let filePath = currentDirectoryPath + "/" + file

guard let json = try? String(contentsOfFile: filePath, encoding: .utf8), let data = json.data(using: .utf8) else {
    print("Error: Invalid JSON")
    exit(1)
}
guard let report = try? JSONDecoder().decode(CoverageReport.self, from: data) else {
    print("Error: Could not decode the report.")
    exit(1)
}

let decimalFormatter = NumberFormatter()
decimalFormatter.numberStyle = .decimal
decimalFormatter.minimumFractionDigits = 2
decimalFormatter.maximumFractionDigits = 2

for target in report.targets {
    let coveragePercent = roundDouble(input: target.coverage * 100.0)
    
    print("\(target.name) coverage: \(coveragePercent)")
}

func roundDouble(input: Double) -> Double {
    let printableCoverage = decimalFormatter.string(from: NSNumber(value: input)) ?? "0.0"
    return Double(printableCoverage) ?? 0.0
}