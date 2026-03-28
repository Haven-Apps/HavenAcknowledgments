import HavenAcknowledgmentsCore
import SwiftUI

/// A searchable list displaying all loaded acknowledgments.
public struct AcknowledgmentsListView: View {
    @Bindable private var loader: AcknowledgmentsLoader
    @State private var searchText = ""

    public init(loader: AcknowledgmentsLoader) {
        self.loader = loader
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
                List(filteredAcknowledgments) { acknowledgment in
                    NavigationLink(value: acknowledgment) {
                        AcknowledgmentRow(acknowledgment: acknowledgment)
                    }
                    .accessibilityHint("Shows the full license for \(acknowledgment.name)")
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search acknowledgments")
        .task {
            if loader.acknowledgments.isEmpty {
                await loader.load()
            }
        }
    }

    private var filteredAcknowledgments: [Acknowledgment] {
        loader.filtered(by: searchText)
    }
}
