import Danger
import Foundation

private extension Danger.File {
    var isInMainSources: Bool { hasPrefix("ios-whitelabel/") }
    var isInDevSources: Bool { hasPrefix("DevelopmentPods/") }
    var isInUInitTests: Bool { hasPrefix("edreams Tests/") }
    var isInUITests: Bool { hasPrefix("edreams UI Tests/") }

    var isSourceFile: Bool {
        hasSuffix(".swift") || hasSuffix(".h") || hasSuffix(".m")
    }
}

private func summarize(from git: Git) {
    let numberOfCreatedFiles = git.createdFiles.count
    let numberOfModifiedFiles = git.modifiedFiles.count
    let numberOfDeletedFiles = git.deletedFiles.count

    let swiftFilesEdited: [String] = git.modifiedFiles.filter { $0.fileType == .swift && fileExists(file: $0) }
    let swiftFilesCreated: [String] = git.createdFiles.filter { $0.fileType == .swift && fileExists(file: $0) }
    let swiftFilesDeleted: [String] = git.deletedFiles.filter { $0.fileType == .swift }

    message("🗑️ Deleted \(numberOfDeletedFiles) files, \(swiftFilesDeleted.count) of them are swift file")
    message("📝 Modified \(numberOfModifiedFiles) files, \(swiftFilesEdited.count) of them are swift file")
    message("🛠️ Created \(numberOfCreatedFiles) files, \(swiftFilesCreated.count) of them are swift file")

    message("**Good job!** Summarized this PR above... 🥳")
}

let danger = Danger()
let git = danger.git
let editedFiles = git.modifiedFiles + git.createdFiles

let hasSourceChanges = editedFiles.contains { $0.isInMainSources || $0.isInDevSources }
let hasSourceChangesInDev = editedFiles.contains { $0.isInDevSources }
let swiftFiles: [String] = editedFiles.filter { $0.fileType == .swift }

let swiftFilesEdited: [String] = git.modifiedFiles.filter { $0.fileType == .swift && fileExists(file: $0) }
let swiftFilesCreated: [String] = git.createdFiles.filter { $0.fileType == .swift && fileExists(file: $0) }

// MARK: -  Summarize files

summarize(from: danger.git)

private func fileExists(file: String) -> Bool { 
    FileManager.default.fileExists(atPath: file)
}

// MARK: - Warn when there is a big PR

if case let sum = editedFiles.count - danger.git.deletedFiles.count, sum > 500 {
    warn("Pull request is relatively big (\(sum) lines changed). If this PR contains multiple changes, consider splitting it into separate PRs for easier reviews.")
}

// MARK: - Warn to update pod version

// Commented for now, we are not working with versions at the moment so this not need.
// if hasSourceChangesInDev, !git.modifiedFiles.contains("*.podspec") {
//     warn("Any changes to library code should update podspec version. Please consider updating podspec version.")
// }

if danger.bitbucketCloud != nil {
    // MARK: - Check if PR has description

    let hasNotDescription = danger.bitbucketCloud.pr.description
    if hasNotDescription.isEmpty {
        message("Please, provide a PR description.")
    }

    // MARK: - Make it more obvious that a PR is a work in progress and shouldn't be merged yet

    if danger.bitbucketCloud?.pr.title.contains("WIP") == true {
        message("PR is marked as Work in Progress, that's mean DO NOT MERGE yet")
    }

    // MARK: - Check for users who approved, check again
    
    var result = CheckResult(title: "Check PR")
    for i in danger.bitbucketCloud.pr.participants where i.approved {
        // markdown("@{\(i.user.accountId ?? "")} there are new changes, please review this PR again. :eyes: ")
        result.askReviewer(to: "@{\(i.user.accountId ?? "")} there are new changes, please review this PR again. :eyes: ")
    }
    if !result.markdownTodos.isEmpty {
        markdown(result.markdownTodos)
    }
}

// MARK: - Check if library was added/removed/modified and need pod install

let xcodeProjectFile: Danger.File = "ios-whitelabel.xcodeproj"
let xcodeProjectWasModified = git.modifiedFiles.contains(xcodeProjectFile)

if editedFiles.contains(where: { $0.isInMainSources && $0.isInDevSources }), !xcodeProjectWasModified {
    fail("Added or removed library files require the Xcode project to be updated.")
}

// MARK: - Running Swiftlint on edited files...

let newWarningsLegacy = SwiftLint.lint(
    .files(swiftFilesEdited),
    inline: false,
    configFile: ".swiftlint.yml",
    strict: false,
    quiet: true,
    swiftlintPath: .bin("Pods/SwiftLint/swiftlint")
)

// MARK: - Running Swiftlint on created files...

let newWarnings = SwiftLint.lint(
    .files(swiftFilesCreated),
    inline: false,
    configFile: ".swiftlint.yml",
    strict: true,
    quiet: true,
    swiftlintPath: .bin("Pods/SwiftLint/swiftlint")
)

var result = CheckResult(title: "SwiftLint found new issues")
for file in newWarningsLegacy {
    let patch = danger.hammer.diffPatch(for: file.file)
    if patch.contains("+\(file.line)") {
        result.check("\(file.reason)(`\(file.ruleID)`) | \(file.file):\(file.line)") { .rejected }
    }
}

if result.warningsCount == 0 && result.errorsCount == 0 && newWarnings.count == 0 {
    message("Well Done 🥳 no new warning has been introduced")
} else {
    fail("You are introducing new warnings to the project, please fix them first.")
    markdown(result.markdownTitle)
    markdown(result.markdownMessage)
}

// MARK: - Virgil - Project integrity check

do {
    struct VirgilOutput: Decodable {
        let warnings: [String]
        let errors: [String]
    }
    let result = try Process.shell("./scripts/check.sh --reporter json")
    let output = try JSONDecoder().decode(VirgilOutput.self, from: result.1.data(using: .utf8)!)
    output.warnings.forEach(warn)
    output.errors.forEach(fail)
} catch {
    fail("\(error)")
}

// MARK: -  To run shell commands

private extension Process {
    static func shell(_ command: String) throws -> (Int32, String) {
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.standardInput = nil

        try task.run()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        task.waitUntilExit()
        return (task.terminationStatus, output)
    }

    static func runShell(_ commands: String...) -> String {
        let task = Process()
        task.launchPath = ProcessInfo().environment["SHELL"]!
        task.environment = ProcessInfo().environment
        task.arguments = ["-c"] + commands

        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!

        return output
    }
}

// MARK: -  To check diff

public struct Hammer {
    let baseBranchResolver: () -> String
    let shellCommandExecutor: (String) -> String    
}

public extension Hammer {    
    func diffPatch(for filename: String) -> String {        
        let command = diffCommand(parsingFile: filename)
        let diff = shellCommandExecutor(command)
        
        return diff        
    }
    
    func diffLines(in filename: String) -> (deletions: [String], additions: [String]) {        
        let patch = diffPatch(for: filename)
        
        let diff = patch.components(separatedBy: "\n").reduce(into: Diff()) { (diff, line) in            
            if line.hasPrefix("---") || line.hasPrefix("+++") {
                return
            }
            
            if line.hasPrefix("-") {
                diff.deletions.append(line)                
            } else if line.hasPrefix("+") {
                diff.additions.append(line)
            }            
        }        
        return (diff.deletions, diff.additions)        
    }    
}

// MARK: - Internal Properties and Methods

public extension Hammer {
    func diffCommand(parsingFile: String) -> String {        
        #"git diff -U0 origin/\#(baseBranchResolver()) -- "\#(parsingFile)""#        
    }    
}

// MARK: - Private Types

private struct Diff {
    var deletions: [String] = []
    var additions: [String] = []
}

extension DangerDSL {    
    public var hammer: Hammer {        
        Hammer(baseBranchResolver: { "dev" }, shellCommandExecutor: { utils.exec($0) })        
    }   
}


// MARK: -  Result checker for custom report

struct CheckResult {
    let title: String

    private(set) var warningsCount = 0
    private(set) var errorsCount = 0

    enum Result {
        case good
        case acceptable
        case rejected

        var markdownSymbol: String {
            switch self {
            case .good:
                return ":tada:"
            case .acceptable:
                return ":warning:"
            case .rejected:
                return ":x:"
            }
        }
    }

    typealias Message = (content: String, result: Result)
    private var messages: [Message] = []

    private var todos: [String] = []

    init(title: String) {
        self.title = title
    }

    mutating func check(_ item: String, execution: () -> Result) {
        let result = execution()
        messages.append((item, result))

        switch result {
        case .good:
            break
        case .acceptable:
            warningsCount += 1
        case .rejected:
            errorsCount += 1
        }
    }

    mutating func askReviewer(to taskToDo: String) {
        todos.append(taskToDo)
    }

    var markdownTitle: String {
        "### " + title
    }

    var markdownMessage: String {
        let chartHeader = """
        | Reason |   File   |
        | --- | -------- |\n
        """
        let chartContent = messages.map {
            "\($0.result.markdownSymbol) \($0.content)"
        } .joined(separator: "\n")
        if chartContent.isEmpty {
            return chartContent
        }
        return chartHeader + chartContent
    }

    var markdownTodos: String {
        let todoContent = todos.map {
            "- [ ] \($0)"
        }
        return todoContent.joined(separator: "\n")
    }
}
