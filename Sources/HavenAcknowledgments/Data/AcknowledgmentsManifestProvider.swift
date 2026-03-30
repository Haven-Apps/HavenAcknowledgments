//
//  AcknowledgmentsManifestProvider.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import Foundation
import HavenAcknowledgmentsCore

/// A protocol that defines how to load an ``AcknowledgmentsManifest``.
///
/// Conform to this protocol to supply acknowledgment data from a custom source.
/// The library ships with two implementations:
///
/// - ``BundleManifestProvider``: Loads the JSON manifest from a `Bundle` resource (default).
/// - ``PreviewManifestProvider``: Returns in-memory sample data for SwiftUI previews.
///
/// ### Creating a Custom Provider
///
/// ```swift
/// struct RemoteManifestProvider: AcknowledgmentsManifestProvider {
///     func loadManifest() async throws -> AcknowledgmentsManifest {
///         let (data, _) = try await URLSession.shared.data(from: manifestURL)
///         return try AcknowledgmentsManifest.decode(from: data)
///     }
/// }
/// ```
public protocol AcknowledgmentsManifestProvider: Sendable {
    /// Loads and returns the acknowledgments manifest.
    ///
    /// - Returns: The decoded ``AcknowledgmentsManifest``.
    /// - Throws: An error if the manifest cannot be loaded or decoded.
    func loadManifest() async throws -> AcknowledgmentsManifest
}
