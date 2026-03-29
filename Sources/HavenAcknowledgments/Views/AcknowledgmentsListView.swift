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
                    Text("loading.message", bundle: .module)
                }
            } else if let errorMessage = loader.errorMessage {
                ContentUnavailableView {
                    Label {
                        Text("error.unableToLoad", bundle: .module)
                    } icon: {
                        Image(systemName: "exclamationmark.triangle")
                    }
                } description: {
                    Text(errorMessage)
                }
            } else if filteredAcknowledgments.isEmpty && !searchText.isEmpty {
                ContentUnavailableView.search(text: searchText)
            } else if loader.acknowledgments.isEmpty {
                ContentUnavailableView {
                    Label {
                        Text("empty.noAcknowledgments", bundle: .module)
                    } icon: {
                        Image(systemName: "doc.text")
                    }
                } description: {
                    Text("empty.noLicensesFound", bundle: .module)
                }
            } else {
                acknowledgmentsList
            }
        }
        .searchable(text: $searchText, prompt: Text("search.prompt", bundle: .module))
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
                .accessibilityHint(Text("accessibility.showsLicenseFor \(acknowledgment.name)", bundle: .module))
        }
        #else
        List(filteredAcknowledgments) { acknowledgment in
            NavigationLink {
                LicenseDetailView(acknowledgment: acknowledgment)
            } label: {
                AcknowledgmentRow(acknowledgment: acknowledgment)
            }
            .accessibilityHint(Text("accessibility.showsLicenseFor \(acknowledgment.name)", bundle: .module))
        }
        #endif
    }

    private var filteredAcknowledgments: [Acknowledgment] {
        loader.filtered(by: searchText)
    }
}
