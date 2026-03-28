import Foundation

@main
struct GeneratorMain {
    static func main() throws {
        let arguments = CommandLine.arguments

        guard arguments.count >= 3 else {
            fputs("Usage: AcknowledgmentsGeneratorTool <package-directory> <output-path>\n", stderr)
            throw GeneratorError.invalidArguments
        }

        let packageDirectory = arguments[1]
        let outputPath = arguments[2]

        let generator = AcknowledgmentsGenerator()
        try generator.generate(packageDirectory: packageDirectory, outputPath: outputPath)
    }
}
