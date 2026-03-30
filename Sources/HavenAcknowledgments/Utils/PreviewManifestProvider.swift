//
//  PreviewManifestProvider.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import Foundation
import HavenAcknowledgmentsCore

/// An ``AcknowledgmentsManifestProvider`` that returns in-memory data,
/// useful for SwiftUI previews and tests.
///
/// ```swift
/// #Preview {
///     HavenAcknowledgmentsView(provider: PreviewManifestProvider())
/// }
/// ```
public struct PreviewManifestProvider: AcknowledgmentsManifestProvider {
    private let manifest: AcknowledgmentsManifest

    /// Creates a provider with the given manifest.
    ///
    /// - Parameter manifest: The manifest to return. Defaults to
    ///   ``AcknowledgmentsPreviewData/sampleManifest``.
    public init(manifest: AcknowledgmentsManifest = AcknowledgmentsPreviewData.sampleManifest) {
        self.manifest = manifest
    }

    public func loadManifest() async throws -> AcknowledgmentsManifest {
        manifest
    }
}
