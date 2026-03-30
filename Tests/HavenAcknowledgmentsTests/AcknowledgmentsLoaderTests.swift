//
//  AcknowledgmentsLoaderTests.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import HavenAcknowledgmentsCore
import Testing

@testable import HavenAcknowledgments

@Suite("AcknowledgmentsLoader Tests")
struct AcknowledgmentsLoaderTests {

    @Test("Loads acknowledgments successfully")
    @MainActor
    func loadsSuccessfully() async {
        let provider = MockManifestProvider()
        let loader = AcknowledgmentsLoader(provider: provider)

        await loader.load()

        #expect(loader.acknowledgments.count == AcknowledgmentsPreviewData.sampleAcknowledgments.count)
        #expect(loader.errorMessage == nil)
        #expect(loader.isLoading == false)
    }

    @Test("Sets error message on failure")
    @MainActor
    func setsErrorOnFailure() async {
        let provider = MockManifestProvider(shouldFail: true)
        let loader = AcknowledgmentsLoader(provider: provider)

        await loader.load()

        #expect(loader.acknowledgments.isEmpty)
        #expect(loader.errorMessage != nil)
        #expect(loader.isLoading == false)
    }

    @Test("Filters acknowledgments by search text")
    @MainActor
    func filtersAcknowledgments() async {
        let provider = MockManifestProvider()
        let loader = AcknowledgmentsLoader(provider: provider)

        await loader.load()

        let filtered = loader.filtered(by: "Alamofire")
        #expect(filtered.count == 1)
        #expect(filtered[0].name == "Alamofire")
    }

    @Test("Returns all acknowledgments when search text is empty")
    @MainActor
    func returnsAllWhenSearchEmpty() async {
        let provider = MockManifestProvider()
        let loader = AcknowledgmentsLoader(provider: provider)

        await loader.load()

        let filtered = loader.filtered(by: "")
        #expect(filtered.count == loader.acknowledgments.count)
    }
}
