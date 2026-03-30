//
//  AcknowledgmentRow.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import HavenAcknowledgmentsCore
import SwiftUI

/// A list row displaying an acknowledgment's name and license type badge.
///
/// This is an internal view used by ``AcknowledgmentsListView`` to render
/// each entry in the list.
struct AcknowledgmentRow: View {
    /// The acknowledgment entry to display.
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
        .accessibilityLabel(Text("accessibility.acknowledgmentRow \(acknowledgment.name) \(acknowledgment.licenseType.displayName)", bundle: .module))
    }
}
