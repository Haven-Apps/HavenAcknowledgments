@_exported import HavenAcknowledgmentsCore
import SwiftUI

/// The main public entry point for the HavenAcknowledgments library.
///
/// Use `HavenAcknowledgmentsView` to display third-party licenses in your app.
///
/// ```swift
/// HavenAcknowledgmentsView()
/// ```
///
/// Or use the `.acknowledgmentsSheet(isPresented:)` modifier:
///
/// ```swift
/// Button("Acknowledgments") {
///     showAcknowledgments = true
/// }
/// .acknowledgmentsSheet(isPresented: $showAcknowledgments)
/// ```
public struct HavenAcknowledgmentsView: View {
    private let provider: AcknowledgmentsManifestProvider

    /// Creates an acknowledgments view using the given manifest provider.
    /// - Parameter provider: The provider to load the manifest from. Defaults to loading
    ///   `Acknowledgments.json` from the main bundle.
    public init(provider: AcknowledgmentsManifestProvider = BundleManifestProvider()) {
        self.provider = provider
    }

    public var body: some View {
        AcknowledgmentsNavigationView(provider: provider)
    }
}
