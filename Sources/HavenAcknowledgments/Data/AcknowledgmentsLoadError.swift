//
//  AcknowledgmentsLoadError.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import Foundation

/// Errors that can occur when loading the acknowledgments manifest at runtime.
///
/// These errors are surfaced by ``BundleManifestProvider`` and displayed
/// in the UI as user-facing error messages.
public enum AcknowledgmentsLoadError: Error, LocalizedError, Sendable {
    /// The manifest JSON file was not found in the bundle.
    ///
    /// - Parameter name: The resource name that was searched for.
    case manifestNotFound(String)

    /// The manifest JSON file was found but could not be decoded.
    ///
    /// - Parameter reason: A description of the decoding failure.
    case decodingFailed(String)

    public var errorDescription: String? {
        switch self {
        case .manifestNotFound(let name):
            return String(localized: "error.manifestNotFound \(name)", bundle: .module)
        case .decodingFailed(let reason):
            return String(localized: "error.decodingFailed \(reason)", bundle: .module)
        }
    }
}
