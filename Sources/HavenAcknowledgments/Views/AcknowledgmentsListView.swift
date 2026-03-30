//
//  AcknowledgmentsListView.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import HavenAcknowledgmentsCore
import SwiftUI

/// A searchable list of all loaded acknowledgments with built-in loading,
/// error, and empty states.
///
/// On iOS the list uses `NavigationLink` to push ``LicenseDetailView``.
/// On macOS it uses selection binding for use inside a `NavigationSplitView`.
///
/// The view automatically calls ``AcknowledgmentsLoader/load()`` when it
/// first appears if no data has been loaded yet.
public struct AcknowledgmentsListView: View {
    @Bindable private var loader: AcknowledgmentsLoader
    @State private var searchText = ""
    @Binding var selectedAcknowledgment: Acknowledgment?

    /// Creates a list view driven by the given loader.
    ///
    /// - Parameters:
    ///   - loader: The ``AcknowledgmentsLoader`` that provides the data.
    ///   - selectedAcknowledgment: A binding to the currently selected
    ///     acknowledgment (used on macOS for split-view selection).
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
