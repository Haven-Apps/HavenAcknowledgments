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
               !acknowledgment.url.isEmpty {
                Button {
                    openURL(packageURL)
                } label: {
                    Label("View Repository", systemImage: "link")
                        .font(.subheadline)
                }
                .accessibilityHint("Opens the package repository in your browser")
            }
        }
    }

    @ViewBuilder
    private var licenseTextSection: some View {
        if acknowledgment.licenseText.isEmpty {
            ContentUnavailableView {
                Label("No License Text", systemImage: "doc.text")
            } description: {
                Text("License text was not included in the manifest.")
            }
        } else {
            Text(acknowledgment.licenseText)
                .font(.caption)
                .monospaced()
                .textSelection(.enabled)
                .accessibilityLabel("License text for \(acknowledgment.name)")
        }
    }
}
