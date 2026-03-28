import Foundation
import HavenAcknowledgmentsCore

/// Default implementation that loads the manifest from a bundle resource.
public struct BundleManifestProvider: AcknowledgmentsManifestProvider {
    private let bundle: Bundle
    private let resourceName: String

    public init(bundle: Bundle = .main, resourceName: String = "Acknowledgments") {
        self.bundle = bundle
        self.resourceName = resourceName
    }

    public func loadManifest() async throws -> AcknowledgmentsManifest {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
            throw AcknowledgmentsLoadError.manifestNotFound(resourceName)
        }

        let data = try Data(contentsOf: url)
        return try AcknowledgmentsManifest.decode(from: data)
    }
}
