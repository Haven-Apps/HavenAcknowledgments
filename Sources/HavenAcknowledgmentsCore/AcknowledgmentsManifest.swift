//
//  AcknowledgmentsManifest.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import Foundation

/// The top-level container for the `Acknowledgments.json` manifest generated
/// by ``HavenAcknowledgmentsPlugin``.
///
/// The build plugin writes this structure as JSON during each build. At runtime
/// the library decodes it via ``decode(from:)`` to populate the UI.
public struct AcknowledgmentsManifest: Codable, Sendable {
    /// The list of acknowledgment entries in this manifest.
    public let acknowledgments: [Acknowledgment]

    /// Creates a manifest with the given acknowledgment entries.
    /// - Parameter acknowledgments: The acknowledgment entries to include.
    public init(acknowledgments: [Acknowledgment]) {
        self.acknowledgments = acknowledgments
    }

    /// Decodes a manifest from JSON data.
    ///
    /// - Parameter data: The raw JSON data to decode.
    /// - Returns: A decoded ``AcknowledgmentsManifest``.
    /// - Throws: A `DecodingError` if the data is not valid JSON or does not
    ///   match the expected schema.
    public static func decode(from data: Data) throws -> AcknowledgmentsManifest {
        let decoder = JSONDecoder()
        return try decoder.decode(AcknowledgmentsManifest.self, from: data)
    }
}
