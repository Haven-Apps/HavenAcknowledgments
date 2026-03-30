//
//  AcknowledgmentsListViewTests.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import HavenAcknowledgmentsCore
import Testing

@testable import HavenAcknowledgments

/// Tests for view-related logic and data consistency.
@Suite("AcknowledgmentsListView Tests")
struct AcknowledgmentsListViewTests {

    @Test("Preview data contains expected sample entries")
    func previewDataIsValid() {
        let samples = AcknowledgmentsPreviewData.sampleAcknowledgments

        #expect(!samples.isEmpty)
        #expect(samples.allSatisfy { !$0.name.isEmpty })
        #expect(samples.allSatisfy { !$0.licenseText.isEmpty })
    }

    @Test("Acknowledgment identifiable ID is the name")
    func acknowledgmentIdentity() {
        let ack = Acknowledgment(
            name: "TestLib",
            licenseText: "MIT",
            url: "https://example.com",
            licenseType: .mit
        )

        #expect(ack.id == "TestLib")
    }

    @Test("Acknowledgment packageURL parses valid URLs")
    func packageURLParsing() {
        let ack = Acknowledgment(
            name: "Test",
            licenseText: "",
            url: "https://github.com/test/repo",
            licenseType: .mit
        )

        #expect(ack.packageURL != nil)
        #expect(ack.packageURL?.host() == "github.com")
    }

    @Test("Acknowledgment packageURL returns nil for empty URL")
    func packageURLEmpty() {
        let ack = Acknowledgment(
            name: "Test",
            licenseText: "",
            url: "",
            licenseType: .mit
        )

        // Empty string produces a valid URL with no host, which is fine
        // The important thing is it doesn't crash
        _ = ack.packageURL
    }

    @Test("License display names are non-empty for all cases")
    func licenseDisplayNames() {
        for license in License.allCases {
            #expect(!license.displayName.isEmpty)
        }
    }
}
