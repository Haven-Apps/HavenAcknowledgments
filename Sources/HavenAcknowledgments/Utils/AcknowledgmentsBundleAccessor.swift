//
//  AcknowledgmentsBundleAccessor.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import Foundation

/// Utility for locating the acknowledgments manifest within a bundle.
public struct AcknowledgmentsBundleAccessor: Sendable {
    private let bundle: Bundle

    public init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    /// Returns the URL of the acknowledgments JSON file in the bundle, if it exists.
    public var manifestURL: URL? {
        bundle.url(forResource: "Acknowledgments", withExtension: "json")
    }

    /// Returns whether an acknowledgments manifest exists in the bundle.
    public var hasManifest: Bool {
        manifestURL != nil
    }
}
