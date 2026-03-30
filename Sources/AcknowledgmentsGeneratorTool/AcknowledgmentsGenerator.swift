//
//  AcknowledgmentsGenerator.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import Foundation
import HavenAcknowledgmentsCore

/// Core logic for scanning Package.resolved and license files to produce an acknowledgments manifest.
struct AcknowledgmentsGenerator {

    /// Model for parsing the SPM `Package.resolved` file format.
    struct ResolvedPackage: Codable {
        let pins: [Pin]
        let version: Int

        struct Pin: Codable {
            let identity: String
            let kind: String
            let location: String
            let state: State

            struct State: Codable {
                let revision: String?
                let version: String?
            }
        }
    }

    /// Common license file names to search for in package checkouts.
    private let licenseFileNames = [
        "LICENSE", "LICENSE.md", "LICENSE.txt", "LICENSE.rst",
        "LICENCE", "LICENCE.md", "LICENCE.txt",
        "License", "License.md", "License.txt",
        "license", "license.md", "license.txt",
        "COPYING", "COPYING.md", "COPYING.txt",
    ]

    // MARK: - Generation

    func generate(packageDirectory: String, outputPath: String, pluginWorkDirectory: String?) throws {
        let pins = parsePackageResolved(in: packageDirectory)
        fputs("HavenAcknowledgments: Found \(pins.count) packages in Package.resolved\n", stderr)

        let checkoutsURL = findCheckoutsDirectory(
            packageDirectory: packageDirectory,
            pluginWorkDirectory: pluginWorkDirectory
        )

        var acknowledgments: [Acknowledgment] = []

        for pin in pins {
            let displayName = deriveDisplayName(from: pin)

            if let checkoutsURL {
                // Checkouts available — only include packages that have a LICENSE file
                let packageDir = checkoutsURL.appendingPathComponent(pin.identity)
                if let licenseInfo = readLicense(in: packageDir) {
                    acknowledgments.append(
                        Acknowledgment(
                            name: displayName,
                            licenseText: licenseInfo.text,
                            url: pin.location,
                            licenseType: licenseInfo.type
                        ))
                }
            } else {
                // Checkouts not found — include all packages with unknown license as fallback
                acknowledgments.append(
                    Acknowledgment(
                        name: displayName,
                        licenseText: "",
                        url: pin.location,
                        licenseType: .unknown
                    ))
            }
        }

        // Merge with any manually provided licenses from a Licenses/ directory
        let manualEntries = scanLicensesDirectory(in: packageDirectory)
        let existingKeys = Set(acknowledgments.map { $0.name.lowercased() })
        for entry in manualEntries where !existingKeys.contains(entry.name.lowercased()) {
            acknowledgments.append(entry)
        }

        fputs("HavenAcknowledgments: Generated \(acknowledgments.count) acknowledgments\n", stderr)

        let manifest = AcknowledgmentsManifest(
            acknowledgments: acknowledgments.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(manifest)

        let outputURL = URL(fileURLWithPath: outputPath)
        try data.write(to: outputURL)
    }

    // MARK: - Package.resolved Parsing

    private func parsePackageResolved(in directory: String) -> [ResolvedPackage.Pin] {
        let directoryURL = URL(fileURLWithPath: directory)
        guard let data = findPackageResolved(in: directoryURL),
            let resolved = try? JSONDecoder().decode(ResolvedPackage.self, from: data)
        else {
            return []
        }
        return resolved.pins
    }

    /// Searches for Package.resolved in common locations:
    /// 1. SPM package root: `<dir>/Package.resolved`
    /// 2. Xcode project: `<dir>/*.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved`
    /// 3. Xcode workspace: `<dir>/*.xcworkspace/xcshareddata/swiftpm/Package.resolved`
    private func findPackageResolved(in directoryURL: URL) -> Data? {
        // SPM package root
        let spmPath = directoryURL.appendingPathComponent("Package.resolved")
        if let data = try? Data(contentsOf: spmPath) {
            return data
        }

        let fm = FileManager.default
        let contents =
            (try? fm.contentsOfDirectory(
                at: directoryURL,
                includingPropertiesForKeys: nil
            )) ?? []

        // Xcode project bundle
        for item in contents where item.pathExtension == "xcodeproj" {
            let resolvedURL =
                item
                .appendingPathComponent("project.xcworkspace")
                .appendingPathComponent("xcshareddata")
                .appendingPathComponent("swiftpm")
                .appendingPathComponent("Package.resolved")
            if let data = try? Data(contentsOf: resolvedURL) {
                return data
            }
        }

        // Xcode workspace bundle
        for item in contents where item.pathExtension == "xcworkspace" {
            let resolvedURL =
                item
                .appendingPathComponent("xcshareddata")
                .appendingPathComponent("swiftpm")
                .appendingPathComponent("Package.resolved")
            if let data = try? Data(contentsOf: resolvedURL) {
                return data
            }
        }

        return nil
    }

    // MARK: - Display Name

    /// Derives a human-readable display name from the package pin.
    /// Prefers the repository URL's last path component (which preserves original casing)
    /// over the lowercased identity field.
    private func deriveDisplayName(from pin: ResolvedPackage.Pin) -> String {
        if let url = URL(string: pin.location) {
            let repoName = url.deletingPathExtension().lastPathComponent
            if !repoName.isEmpty {
                if repoName.contains("-") {
                    return
                        repoName
                        .split(separator: "-")
                        .map { $0.prefix(1).uppercased() + $0.dropFirst() }
                        .joined(separator: " ")
                }
                return repoName
            }
        }

        // Fallback to identity-based name
        return pin.identity
            .split(separator: "-")
            .map { $0.prefix(1).uppercased() + $0.dropFirst() }
            .joined(separator: " ")
    }

    // MARK: - Checkouts Discovery

    /// Finds the SPM checkouts directory by searching common locations.
    private func findCheckoutsDirectory(packageDirectory: String, pluginWorkDirectory: String?) -> URL? {
        let fm = FileManager.default

        // SPM CLI: .build/checkouts/
        let spmCheckouts = URL(fileURLWithPath: packageDirectory)
            .appendingPathComponent(".build")
            .appendingPathComponent("checkouts")
        if fm.fileExists(atPath: spmCheckouts.path) {
            fputs("HavenAcknowledgments: Found checkouts at \(spmCheckouts.path)\n", stderr)
            return spmCheckouts
        }

        // Xcode: search upward from the plugin work directory.
        // Check both `checkouts/` (SPM structure) and `SourcePackages/checkouts/` (DerivedData structure)
        // at each level, since the plugin work dir may be under Build/Intermediates.noindex/
        if let pluginWorkDir = pluginWorkDirectory {
            fputs("HavenAcknowledgments: Searching for checkouts from plugin work dir: \(pluginWorkDir)\n", stderr)
            var current = URL(fileURLWithPath: pluginWorkDir)
            for _ in 0..<15 {
                // Direct child: <dir>/checkouts/
                let directCheckouts = current.appendingPathComponent("checkouts")
                if fm.fileExists(atPath: directCheckouts.path) {
                    fputs("HavenAcknowledgments: Found checkouts at \(directCheckouts.path)\n", stderr)
                    return directCheckouts
                }
                // Xcode DerivedData: <dir>/SourcePackages/checkouts/
                let sourcePackagesCheckouts =
                    current
                    .appendingPathComponent("SourcePackages")
                    .appendingPathComponent("checkouts")
                if fm.fileExists(atPath: sourcePackagesCheckouts.path) {
                    fputs("HavenAcknowledgments: Found checkouts at \(sourcePackagesCheckouts.path)\n", stderr)
                    return sourcePackagesCheckouts
                }
                let parent = current.deletingLastPathComponent()
                if parent.path == current.path { break }
                current = parent
            }
        }

        fputs("HavenAcknowledgments: Could not find checkouts directory\n", stderr)
        fputs("  Searched .build/checkouts/ at: \(packageDirectory)\n", stderr)
        if let pwd = pluginWorkDirectory {
            fputs("  Searched upward from: \(pwd)\n", stderr)
        }
        return nil
    }

    // MARK: - License File Reading

    /// Reads the license file from a package checkout directory and detects its type.
    private func readLicense(in directoryURL: URL) -> (text: String, type: License)? {
        for name in licenseFileNames {
            let fileURL = directoryURL.appendingPathComponent(name)
            if let text = try? String(contentsOf: fileURL, encoding: .utf8), !text.isEmpty {
                return (text, License.detect(from: text))
            }
        }
        return nil
    }

    // MARK: - Licenses/ Directory Scanning

    private func scanLicensesDirectory(in directory: String) -> [Acknowledgment] {
        let licensesURL = URL(fileURLWithPath: directory)
            .appendingPathComponent("Licenses")

        guard
            let contents = try? FileManager.default.contentsOfDirectory(
                at: licensesURL,
                includingPropertiesForKeys: nil
            )
        else {
            return []
        }

        return contents.compactMap { fileURL -> Acknowledgment? in
            guard let text = try? String(contentsOf: fileURL, encoding: .utf8) else {
                return nil
            }

            let name = fileURL.deletingPathExtension().lastPathComponent

            return Acknowledgment(
                name: name,
                licenseText: text,
                url: "",
                licenseType: License.detect(from: text)
            )
        }
    }
}
