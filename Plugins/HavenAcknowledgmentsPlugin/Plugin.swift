import PackagePlugin

@main
struct AcknowledgmentsPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let tool = try context.tool(named: "AcknowledgmentsGeneratorTool")
        let outputPath = context.pluginWorkDirectoryURL
            .appending(path: "Acknowledgments.json")

        return [
            .prebuildCommand(
                displayName: "Generate Acknowledgments Manifest",
                executable: tool.url,
                arguments: [
                    context.package.directoryURL.path(),
                    outputPath.path(),
                ],
                outputFilesDirectory: context.pluginWorkDirectoryURL
            ),
        ]
    }
}
