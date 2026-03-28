import Foundation

enum GeneratorError: Error, CustomStringConvertible {
    case invalidArguments

    var description: String {
        switch self {
        case .invalidArguments:
            return "Expected arguments: <package-directory> <output-path>"
        }
    }
}
