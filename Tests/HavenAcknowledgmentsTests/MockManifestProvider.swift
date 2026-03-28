import HavenAcknowledgmentsCore
@testable import HavenAcknowledgments

/// A mock manifest provider for testing.
struct MockManifestProvider: AcknowledgmentsManifestProvider {
    let manifest: AcknowledgmentsManifest
    let shouldFail: Bool

    init(
        manifest: AcknowledgmentsManifest = AcknowledgmentsPreviewData.sampleManifest,
        shouldFail: Bool = false
    ) {
        self.manifest = manifest
        self.shouldFail = shouldFail
    }

    func loadManifest() async throws -> AcknowledgmentsManifest {
        if shouldFail {
            throw AcknowledgmentsLoadError.manifestNotFound("Mock")
        }
        return manifest
    }
}
