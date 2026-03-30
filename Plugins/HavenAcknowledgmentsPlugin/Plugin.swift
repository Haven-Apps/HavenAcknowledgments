//
//  PackagePlugin.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import PackagePlugin

/// A Swift Package Manager build tool plugin that generates an
/// `Acknowledgments.json` manifest during each build.
///
/// The plugin invokes the `AcknowledgmentsGeneratorTool` executable, passing
/// the package directory, output path, and plugin work directory. The tool
/// scans `Package.resolved` and reads license files from SPM checkouts.
///
/// ## Setup
///
/// Add the plugin to your target in `Package.swift`:
///
/// ```swift
/// .target(
///     name: "MyApp",
///     dependencies: ["HavenAcknowledgments"],
///     plugins: [.plugin(name: "HavenAcknowledgmentsPlugin", package: "HavenAcknowledgments")]
/// )
/// ```
///
/// Or in Xcode, add it under your target's **Build Phases > Run Build Tool Plug-ins**.
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
                    context.pluginWorkDirectoryURL.path(),
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
                    context.pluginWorkDirectoryURL.path(),
                ],
                outputFiles: [outputPath]
            ),
        ]
    }
}
#endif
