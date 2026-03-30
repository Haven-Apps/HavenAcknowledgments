//
//  AcknowledgmentsNavigationView.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

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
