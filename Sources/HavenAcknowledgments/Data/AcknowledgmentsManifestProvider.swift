import Foundation
import HavenAcknowledgmentsCore

/// Protocol defining how to load an acknowledgments manifest.
public protocol AcknowledgmentsManifestProvider: Sendable {
    /// Loads the acknowledgments manifest asynchronously.
    func loadManifest() async throws -> AcknowledgmentsManifest
}
