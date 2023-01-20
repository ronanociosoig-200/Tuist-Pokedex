import ProjectDescription

let workspace = Workspace(
    name: "Pokedex",
    projects: ["./**"],
    generationOptions: .options(
        autogeneratedWorkspaceSchemes:
                .enabled(codeCoverageMode: .all,
                         testingOptions: [
                            .parallelizable,
                            .randomExecutionOrdering])
    )
)
