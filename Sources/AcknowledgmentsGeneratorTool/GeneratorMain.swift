//
//  GeneratorMain.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import Foundation

@main
struct GeneratorMain {
    static func main() throws {
        let arguments = CommandLine.arguments

        guard arguments.count >= 3 else {
            fputs("Usage: AcknowledgmentsGeneratorTool <package-directory> <output-path> [plugin-work-directory]\n", stderr)
            throw GeneratorError.invalidArguments
        }

        let packageDirectory = arguments[1]
        let outputPath = arguments[2]
        let pluginWorkDirectory = arguments.count >= 4 ? arguments[3] : nil

        let generator = AcknowledgmentsGenerator()
        try generator.generate(
            packageDirectory: packageDirectory,
            outputPath: outputPath,
            pluginWorkDirectory: pluginWorkDirectory
        )
    }
}
