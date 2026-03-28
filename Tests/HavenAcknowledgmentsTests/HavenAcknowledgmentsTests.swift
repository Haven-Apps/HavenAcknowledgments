import Foundation
import HavenAcknowledgmentsCore
import Testing
@testable import HavenAcknowledgments

/// Tests for `AcknowledgmentsManifest` encoding and decoding.
@Suite("Manifest Tests")
struct ManifestTests {

    @Test("Decodes valid JSON manifest")
    func decodesValidManifest() throws {
        let json = """
        {
            "acknowledgments": [
                {
                    "name": "TestLib",
                    "licenseText": "MIT License text",
                    "url": "https://github.com/test/lib",
                    "licenseType": "MIT"
                }
            ]
        }
        """
        let data = Data(json.utf8)
        let manifest = try AcknowledgmentsManifest.decode(from: data)

        #expect(manifest.acknowledgments.count == 1)
        #expect(manifest.acknowledgments[0].name == "TestLib")
        #expect(manifest.acknowledgments[0].licenseType == .mit)
        #expect(manifest.acknowledgments[0].url == "https://github.com/test/lib")
    }

    @Test("Decodes empty acknowledgments array")
    func decodesEmptyManifest() throws {
        let json = """
        { "acknowledgments": [] }
        """
        let data = Data(json.utf8)
        let manifest = try AcknowledgmentsManifest.decode(from: data)

        #expect(manifest.acknowledgments.isEmpty)
    }

    @Test("Decodes unknown license type as .unknown")
    func decodesUnknownLicenseType() throws {
        let json = """
        {
            "acknowledgments": [
                {
                    "name": "Foo",
                    "licenseText": "",
                    "url": "",
                    "licenseType": "SomeWeirdLicense"
                }
            ]
        }
        """
        let data = Data(json.utf8)
        let manifest = try AcknowledgmentsManifest.decode(from: data)

        #expect(manifest.acknowledgments[0].licenseType == .unknown)
    }

    @Test("Round-trips through encode and decode")
    func roundTrips() throws {
        let original = AcknowledgmentsManifest(
            acknowledgments: [
                Acknowledgment(
                    name: "RoundTrip",
                    licenseText: "Some license",
                    url: "https://example.com",
                    licenseType: .apache2
                ),
            ]
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        let decoded = try AcknowledgmentsManifest.decode(from: data)

        #expect(decoded.acknowledgments.count == 1)
        #expect(decoded.acknowledgments[0].name == "RoundTrip")
        #expect(decoded.acknowledgments[0].licenseType == .apache2)
    }
}
