//
//  AcknowledgmentsLoader.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import Foundation
import HavenAcknowledgmentsCore
import Observation

/// Observable loader that provides acknowledgments data to SwiftUI views.
@MainActor
@Observable
public final class AcknowledgmentsLoader {
    /// The loaded acknowledgments, empty until `load()` completes.
    public private(set) var acknowledgments: [Acknowledgment] = []

    /// Whether the loader is currently loading data.
    public private(set) var isLoading = false

    /// An error message if loading failed, `nil` otherwise.
    public private(set) var errorMessage: String?

    private let provider: AcknowledgmentsManifestProvider

    public init(provider: AcknowledgmentsManifestProvider = BundleManifestProvider()) {
        self.provider = provider
    }

    /// Loads acknowledgments from the manifest provider.
    public func load() async {
        isLoading = true
        errorMessage = nil

        do {
            let manifest = try await provider.loadManifest()
            acknowledgments = manifest.acknowledgments
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    /// Returns acknowledgments filtered by the given search text.
    public func filtered(by searchText: String) -> [Acknowledgment] {
        guard !searchText.isEmpty else { return acknowledgments }

        return acknowledgments.filter { acknowledgment in
            acknowledgment.name.localizedCaseInsensitiveContains(searchText)
                || acknowledgment.licenseType.displayName.localizedCaseInsensitiveContains(searchText)
        }
    }
}
