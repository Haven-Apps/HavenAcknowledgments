//
//  GeneratorError.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import Foundation

/// Errors thrown by the acknowledgments generator command-line tool.
enum GeneratorError: Error, CustomStringConvertible {
    /// The required command-line arguments were not provided.
    case invalidArguments

    var description: String {
        switch self {
        case .invalidArguments:
            return "Expected arguments: <package-directory> <output-path>"
        }
    }
}
