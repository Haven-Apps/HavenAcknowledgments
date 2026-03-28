import Foundation

/// A single third-party acknowledgment entry containing package metadata and license information.
public struct Acknowledgment: Codable, Sendable, Identifiable, Hashable {
    public let name: String
    public let licenseText: String
    public let url: String
    public let licenseType: License

    public var id: String { name }

    /// The package URL parsed as a `URL`, if valid.
    public var packageURL: URL? {
        URL(string: url)
    }

    public init(name: String, licenseText: String, url: String, licenseType: License) {
        self.name = name
        self.licenseText = licenseText
        self.url = url
        self.licenseType = licenseType
    }

    // Custom coding to handle raw string license types from the generated JSON
    enum CodingKeys: String, CodingKey {
        case name
        case licenseText
        case url
        case licenseType
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        licenseText = try container.decode(String.self, forKey: .licenseText)
        url = try container.decode(String.self, forKey: .url)

        let typeString = try container.decode(String.self, forKey: .licenseType)
        licenseType = License(rawValue: typeString) ?? .unknown
    }
}
