//
//  HavenAcknowledgments.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

@_exported import HavenAcknowledgmentsCore
import SwiftUI

/// The primary entry point for displaying third-party license acknowledgments.
///
/// Drop `HavenAcknowledgmentsView` into any SwiftUI hierarchy to show a
/// searchable, platform-adaptive list of open-source licenses:
///
/// ```swift
/// HavenAcknowledgmentsView()
/// ```
///
/// Or present it as a sheet using the convenience modifier:
///
/// ```swift
/// Button("Acknowledgments") {
///     showAcknowledgments = true
/// }
/// .acknowledgmentsSheet(isPresented: $showAcknowledgments)
/// ```
///
/// ## How It Works
///
/// 1. The ``HavenAcknowledgmentsPlugin`` build plugin scans your
///    `Package.resolved` and package checkouts at build time.
/// 2. It generates an `Acknowledgments.json` manifest.
/// 3. This view loads that manifest via ``BundleManifestProvider`` and
///    renders the entries.
///
/// ## Topics
///
/// ### Presenting Acknowledgments
/// - ``init(provider:)``
/// - ``SwiftUICore/View/acknowledgmentsSheet(isPresented:provider:)``
///
/// ### Data Loading
/// - ``AcknowledgmentsLoader``
/// - ``AcknowledgmentsManifestProvider``
/// - ``BundleManifestProvider``
///
/// ### Views
/// - ``AcknowledgmentsListView``
/// - ``LicenseDetailView``
/// - ``AcknowledgmentsNavigationView``
public struct HavenAcknowledgmentsView: View {
    private let provider: AcknowledgmentsManifestProvider

    /// Creates an acknowledgments view using the given manifest provider.
    ///
    /// - Parameter provider: The provider to load the manifest from. Defaults
    ///   to ``BundleManifestProvider``, which reads `Acknowledgments.json`
    ///   from the main bundle.
    public init(provider: AcknowledgmentsManifestProvider = BundleManifestProvider()) {
        self.provider = provider
    }

    public var body: some View {
        AcknowledgmentsNavigationView(provider: provider)
    }
}
