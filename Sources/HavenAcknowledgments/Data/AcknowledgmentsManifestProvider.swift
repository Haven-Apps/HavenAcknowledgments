//
//  AcknowledgmentsManifestProvider.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import Foundation
import HavenAcknowledgmentsCore

/// Protocol defining how to load an acknowledgments manifest.
public protocol AcknowledgmentsManifestProvider: Sendable {
    /// Loads the acknowledgments manifest asynchronously.
    func loadManifest() async throws -> AcknowledgmentsManifest
}
