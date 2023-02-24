import ProjectDescription

let config = Config(
    cloud: .cloud(projectId: "ronanoc/Tuist-Pokedex", url: "https://cloud.tuist.io", options: [.optional, .analytics]),
    plugins: [.git(url: "https://github.com/tuist/tuist-plugin-lint", tag: "0.3.0"),
              .git(url: "https://github.com/ronanociosoig-200/SourceryPlugin", tag: "0.1.0")]
)

