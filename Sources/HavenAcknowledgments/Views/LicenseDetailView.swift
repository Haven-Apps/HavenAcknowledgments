//
//  LicenseDetailView.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import HavenAcknowledgmentsCore
import SwiftUI

/// A detail view showing the full license text and a link to the package repository.
public struct LicenseDetailView: View {
    let acknowledgment: Acknowledgment
    @Environment(\.openURL) private var openURL

    public init(acknowledgment: Acknowledgment) {
        self.acknowledgment = acknowledgment
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                headerSection
                licenseTextSection
            }
            .padding()
        }
        .navigationTitle(acknowledgment.name)
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(acknowledgment.licenseType.displayName, systemImage: "doc.text")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if let packageURL = acknowledgment.packageURL,
                !acknowledgment.url.isEmpty
            {
                Button {
                    openURL(packageURL)
                } label: {
                    Label {
                        Text("detail.viewRepository", bundle: .module)
                    } icon: {
                        Image(systemName: "link")
                    }
                    .font(.subheadline)
                }
                .accessibilityHint(Text("accessibility.opensRepository", bundle: .module))
            }
        }
    }

    @ViewBuilder
    private var licenseTextSection: some View {
        if acknowledgment.licenseText.isEmpty {
            ContentUnavailableView {
                Label {
                    Text("detail.noLicenseText", bundle: .module)
                } icon: {
                    Image(systemName: "doc.text")
                }
            } description: {
                Text("detail.noLicenseTextDescription", bundle: .module)
            }
        } else if let markdown = try? AttributedString(
            markdown: acknowledgment.licenseText,
            options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        ) {
            Text(markdown)
                .font(.caption)
                .textSelection(.enabled)
                .accessibilityLabel(Text("accessibility.licenseTextFor \(acknowledgment.name)", bundle: .module))
        } else {
            Text(acknowledgment.licenseText)
                .font(.caption)
                .textSelection(.enabled)
                .accessibilityLabel(Text("accessibility.licenseTextFor \(acknowledgment.name)", bundle: .module))
        }
    }
}
