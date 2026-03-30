//
//  Acknowledgment.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import Foundation

/// A single third-party acknowledgment containing package metadata and license information.
///
/// Each `Acknowledgment` represents one dependency in the generated manifest.
/// The build plugin creates these automatically by scanning `Package.resolved`
/// and reading license files from SPM checkouts.
///
/// ```swift
/// let entry = Acknowledgment(
///     name: "Alamofire",
///     licenseText: "MIT License\n...",
///     url: "https://github.com/Alamofire/Alamofire",
///     licenseType: .mit
/// )
/// ```
public struct Acknowledgment: Codable, Sendable, Identifiable, Hashable {
    /// The display name of the package (e.g. `"Alamofire"`).
    public let name: String

    /// The full text of the package's license file.
    public let licenseText: String

    /// The repository URL string for the package.
    public let url: String

    /// The detected or declared license type.
    public let licenseType: License

    /// The stable identity for this acknowledgment, derived from ``name``.
    public var id: String { name }

    /// The repository URL parsed as a `URL`, or `nil` if ``url`` is not a valid URL.
    public var packageURL: URL? {
        URL(string: url)
    }

    /// Creates a new acknowledgment entry.
    ///
    /// - Parameters:
    ///   - name: The display name of the package.
    ///   - licenseText: The full text of the license file.
    ///   - url: The repository URL string.
    ///   - licenseType: The license type for this package.
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
