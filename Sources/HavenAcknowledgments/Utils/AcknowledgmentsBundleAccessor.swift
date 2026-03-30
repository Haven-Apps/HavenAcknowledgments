//
//  AcknowledgmentsBundleAccessor.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import Foundation

/// A lightweight helper for checking whether an `Acknowledgments.json` file
/// exists in a given bundle.
///
/// Use this to conditionally show acknowledgments UI only when data is
/// available:
///
/// ```swift
/// let accessor = AcknowledgmentsBundleAccessor()
/// if accessor.hasManifest {
///     // Show acknowledgments button
/// }
/// ```
public struct AcknowledgmentsBundleAccessor: Sendable {
    private let bundle: Bundle

    /// Creates an accessor for the given bundle.
    ///
    /// - Parameter bundle: The bundle to search. Defaults to `.main`.
    public init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    /// The URL of the `Acknowledgments.json` file in the bundle, or `nil`
    /// if no such resource exists.
    public var manifestURL: URL? {
        bundle.url(forResource: "Acknowledgments", withExtension: "json")
    }

    /// A Boolean value indicating whether the bundle contains an
    /// acknowledgments manifest.
    public var hasManifest: Bool {
        manifestURL != nil
    }
}
