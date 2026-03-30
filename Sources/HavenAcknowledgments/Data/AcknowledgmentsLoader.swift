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

/// An observable data loader that fetches acknowledgment entries from an
/// ``AcknowledgmentsManifestProvider`` and drives the SwiftUI views.
///
/// `AcknowledgmentsLoader` uses the `@Observable` macro so SwiftUI views
/// automatically update when ``acknowledgments``, ``isLoading``, or
/// ``errorMessage`` change.
///
/// You typically don't need to interact with this class directly — the
/// library's views create and manage their own loader. However, you can
/// use it if you need to build a custom UI:
///
/// ```swift
/// @State private var loader = AcknowledgmentsLoader()
///
/// var body: some View {
///     List(loader.acknowledgments) { item in
///         Text(item.name)
///     }
///     .task { await loader.load() }
/// }
/// ```
@MainActor
@Observable
public final class AcknowledgmentsLoader {
    /// The loaded acknowledgments, empty until ``load()`` completes successfully.
    public private(set) var acknowledgments: [Acknowledgment] = []

    /// A Boolean value indicating whether the loader is currently fetching data.
    public private(set) var isLoading = false

    /// A localized error message if loading failed, or `nil` on success.
    public private(set) var errorMessage: String?

    private let provider: AcknowledgmentsManifestProvider

    /// Creates a loader backed by the given manifest provider.
    ///
    /// - Parameter provider: The provider to load the manifest from.
    ///   Defaults to ``BundleManifestProvider``.
    public init(provider: AcknowledgmentsManifestProvider = BundleManifestProvider()) {
        self.provider = provider
    }

    /// Loads acknowledgments from the configured provider.
    ///
    /// On success, ``acknowledgments`` is populated and ``errorMessage`` is
    /// cleared. On failure, ``errorMessage`` contains a localized description.
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

    /// Returns acknowledgments whose name or license type matches the search text.
    ///
    /// Matching is case-insensitive and locale-aware. When `searchText` is empty,
    /// all acknowledgments are returned.
    ///
    /// - Parameter searchText: The text to filter by.
    /// - Returns: A filtered array of ``Acknowledgment`` entries.
    public func filtered(by searchText: String) -> [Acknowledgment] {
        guard !searchText.isEmpty else { return acknowledgments }

        return acknowledgments.filter { acknowledgment in
            acknowledgment.name.localizedCaseInsensitiveContains(searchText)
                || acknowledgment.licenseType.displayName.localizedCaseInsensitiveContains(searchText)
        }
    }
}
