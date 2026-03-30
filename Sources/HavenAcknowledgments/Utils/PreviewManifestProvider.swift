//
//  PreviewManifestProvider.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import Foundation
import HavenAcknowledgmentsCore

/// A manifest provider that returns in-memory preview data.
public struct PreviewManifestProvider: AcknowledgmentsManifestProvider {
    private let manifest: AcknowledgmentsManifest

    public init(manifest: AcknowledgmentsManifest = AcknowledgmentsPreviewData.sampleManifest) {
        self.manifest = manifest
    }

    public func loadManifest() async throws -> AcknowledgmentsManifest {
        manifest
    }
}
