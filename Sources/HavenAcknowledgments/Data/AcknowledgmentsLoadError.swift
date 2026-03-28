import Foundation

/// Errors that can occur when loading acknowledgments.
public enum AcknowledgmentsLoadError: Error, LocalizedError, Sendable {
    case manifestNotFound(String)
    case decodingFailed(String)

    public var errorDescription: String? {
        switch self {
        case .manifestNotFound(let name):
            return "Acknowledgments manifest '\(name).json' not found in bundle."
        case .decodingFailed(let reason):
            return "Failed to decode acknowledgments manifest: \(reason)"
        }
    }
}
