//
//  AcknowledgmentsNavigationView.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import HavenAcknowledgmentsCore
import SwiftUI

/// A platform-adaptive navigation container for the acknowledgments UI.
///
/// On macOS this uses a `NavigationSplitView` with a sidebar list and
/// detail pane. On iOS it uses a `NavigationStack` with push navigation.
///
/// You rarely need to use this view directly — prefer
/// ``HavenAcknowledgmentsView`` or the
/// ``SwiftUICore/View/acknowledgmentsSheet(isPresented:provider:)`` modifier
/// instead.
public struct AcknowledgmentsNavigationView: View {
    @State private var loader: AcknowledgmentsLoader
    @State private var selectedAcknowledgment: Acknowledgment?

    /// Creates a navigation view using the given manifest provider.
    ///
    /// - Parameter provider: The provider that supplies the acknowledgments
    ///   manifest. Defaults to ``BundleManifestProvider``.
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
                        Label {
                            Text("placeholder.selectPackage", bundle: .module)
                        } icon: {
                            Image(systemName: "doc.text")
                        }
                    } description: {
                        Text("placeholder.selectPackageDescription", bundle: .module)
                    }
                }
            }
            .navigationTitle(Text("navigation.title", bundle: .module))
        #else
            NavigationStack {
                AcknowledgmentsListView(loader: loader)
                    .navigationTitle(Text("navigation.title", bundle: .module))
            }
        #endif
    }
}
