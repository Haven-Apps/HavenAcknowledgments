//
//  BundleManifestProvider.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import Foundation
import HavenAcknowledgmentsCore

/// The default ``AcknowledgmentsManifestProvider`` that loads the JSON manifest
/// from a `Bundle` resource.
///
/// By default this looks for an `Acknowledgments.json` file in the main bundle.
/// The build plugin generates this file automatically during each build.
///
/// You can customize the bundle or resource name if your project layout differs:
///
/// ```swift
/// let provider = BundleManifestProvider(
///     bundle: .module,
///     resourceName: "MyCustomAcknowledgments"
/// )
/// ```
public struct BundleManifestProvider: AcknowledgmentsManifestProvider {
    private let bundle: Bundle
    private let resourceName: String

    /// Creates a provider that loads the manifest from the given bundle.
    ///
    /// - Parameters:
    ///   - bundle: The bundle containing the JSON resource. Defaults to `.main`.
    ///   - resourceName: The name of the JSON resource (without extension).
    ///     Defaults to `"Acknowledgments"`.
    public init(bundle: Bundle = .main, resourceName: String = "Acknowledgments") {
        self.bundle = bundle
        self.resourceName = resourceName
    }

    /// Loads the manifest from the bundle resource.
    ///
    /// - Returns: The decoded ``AcknowledgmentsManifest``.
    /// - Throws: ``AcknowledgmentsLoadError/manifestNotFound(_:)`` if the
    ///   resource does not exist in the bundle.
    public func loadManifest() async throws -> AcknowledgmentsManifest {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
            throw AcknowledgmentsLoadError.manifestNotFound(resourceName)
        }

        let data = try Data(contentsOf: url)
        return try AcknowledgmentsManifest.decode(from: data)
    }
}
