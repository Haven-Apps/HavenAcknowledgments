import HavenAcknowledgmentsCore
import SwiftUI

/// A searchable list displaying all loaded acknowledgments.
public struct AcknowledgmentsListView: View {
    @Bindable private var loader: AcknowledgmentsLoader
    @State private var searchText = ""
    @Binding var selectedAcknowledgment: Acknowledgment?

    public init(loader: AcknowledgmentsLoader, selectedAcknowledgment: Binding<Acknowledgment?> = .constant(nil)) {
        self.loader = loader
        _selectedAcknowledgment = selectedAcknowledgment
    }

    public var body: some View {
        Group {
            if loader.isLoading {
                ProgressView {
                    Text("Loading acknowledgments…")
                }
            } else if let errorMessage = loader.errorMessage {
                ContentUnavailableView {
                    Label("Unable to Load", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(errorMessage)
                }
            } else if filteredAcknowledgments.isEmpty && !searchText.isEmpty {
                ContentUnavailableView.search(text: searchText)
            } else if loader.acknowledgments.isEmpty {
                ContentUnavailableView {
                    Label("No Acknowledgments", systemImage: "doc.text")
                } description: {
                    Text("No third-party licenses found.")
                }
            } else {
                acknowledgmentsList
            }
        }
        .searchable(text: $searchText, prompt: "Search acknowledgments")
        .task {
            if loader.acknowledgments.isEmpty {
                await loader.load()
            }
        }
    }

    @ViewBuilder
    private var acknowledgmentsList: some View {
        #if os(macOS)
        List(filteredAcknowledgments, selection: $selectedAcknowledgment) { acknowledgment in
            AcknowledgmentRow(acknowledgment: acknowledgment)
                .tag(acknowledgment)
                .accessibilityHint("Shows the full license for \(acknowledgment.name)")
        }
        #else
        List(filteredAcknowledgments) { acknowledgment in
            NavigationLink {
                LicenseDetailView(acknowledgment: acknowledgment)
            } label: {
                AcknowledgmentRow(acknowledgment: acknowledgment)
            }
            .accessibilityHint("Shows the full license for \(acknowledgment.name)")
        }
        #endif
    }

    private var filteredAcknowledgments: [Acknowledgment] {
        loader.filtered(by: searchText)
    }
}
