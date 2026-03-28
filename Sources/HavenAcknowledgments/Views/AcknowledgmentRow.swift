import HavenAcknowledgmentsCore
import SwiftUI

/// A row displaying a single acknowledgment's name and license type.
struct AcknowledgmentRow: View {
    let acknowledgment: Acknowledgment

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(acknowledgment.name)
                .font(.body)
                .accessibilityAddTraits(.isHeader)

            Text(acknowledgment.licenseType.displayName)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(acknowledgment.name), \(acknowledgment.licenseType.displayName)")
    }
}
