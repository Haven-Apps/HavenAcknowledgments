import PackagePlugin

@main
struct AcknowledgmentsPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let tool = try context.tool(named: "AcknowledgmentsGeneratorTool")
        let outputPath = context.pluginWorkDirectoryURL
            .appending(path: "Acknowledgments.json")

        return [
            .buildCommand(
                displayName: "Generate Acknowledgments Manifest",
                executable: tool.url,
                arguments: [
                    context.package.directoryURL.path(),
                    outputPath.path(),
                ],
                inputFiles: [
                    context.package.directoryURL.appending(path: "Package.resolved"),
                ],
                outputFiles: [outputPath]
            ),
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension AcknowledgmentsPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let tool = try context.tool(named: "AcknowledgmentsGeneratorTool")
        let outputPath = context.pluginWorkDirectoryURL
            .appending(path: "Acknowledgments.json")

        return [
            .buildCommand(
                displayName: "Generate Acknowledgments Manifest",
                executable: tool.url,
                arguments: [
                    context.xcodeProject.directoryURL.path(),
                    outputPath.path(),
                ],
                outputFiles: [outputPath]
            ),
        ]
    }
}
#endif
