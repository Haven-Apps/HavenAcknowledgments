//
//  AcknowledgmentsLoadError.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import Foundation

/// Errors that can occur when loading acknowledgments.
public enum AcknowledgmentsLoadError: Error, LocalizedError, Sendable {
    case manifestNotFound(String)
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
