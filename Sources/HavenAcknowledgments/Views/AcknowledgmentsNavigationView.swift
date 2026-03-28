import HavenAcknowledgmentsCore
import SwiftUI

/// A navigation wrapper that provides a NavigationSplitView on macOS and NavigationStack on iOS.
public struct AcknowledgmentsNavigationView: View {
    @State private var loader: AcknowledgmentsLoader
    @State private var selectedAcknowledgment: Acknowledgment?

    public init(provider: AcknowledgmentsManifestProvider = BundleManifestProvider()) {
        _loader = State(initialValue: AcknowledgmentsLoader(provider: provider))
    }

    public var body: some View {
        #if os(macOS)
        NavigationSplitView {
            AcknowledgmentsListView(loader: loader, selectedAcknowledgment: $selectedAcknowledgment)
                .navigationSplitViewColumnWidth(min: 220, ideal: 280)
        } detail: {
            if let selected = selectedAcknowledgment {
                LicenseDetailView(acknowledgment: selected)
            } else {
                ContentUnavailableView {
                    Label("Select a Package", systemImage: "doc.text")
                } description: {
                    Text("Choose a package from the sidebar to view its license.")
                }
            }
        }
        .navigationTitle("Acknowledgments")
        #else
        NavigationStack {
            AcknowledgmentsListView(loader: loader)
                .navigationTitle("Acknowledgments")
        }
        #endif
    }
}
