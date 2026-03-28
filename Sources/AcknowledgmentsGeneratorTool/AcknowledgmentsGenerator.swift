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

    // MARK: - Generation

    func generate(packageDirectory: String, outputPath: String) throws {
        let resolvedEntries = scanPackageResolved(in: packageDirectory)
        let licenseEntries = scanLicensesDirectory(in: packageDirectory)

        let merged = mergeEntries(
            resolvedEntries: resolvedEntries,
            licenseEntries: licenseEntries
        )

        let manifest = AcknowledgmentsManifest(
            acknowledgments: merged.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(manifest)

        let outputURL = URL(fileURLWithPath: outputPath)
        try data.write(to: outputURL)
    }

    // MARK: - Package.resolved Scanning

    private func scanPackageResolved(in directory: String) -> [Acknowledgment] {
        let resolvedURL = URL(fileURLWithPath: directory)
            .appendingPathComponent("Package.resolved")

        guard let data = try? Data(contentsOf: resolvedURL),
              let resolved = try? JSONDecoder().decode(ResolvedPackage.self, from: data) else {
            return []
        }

        return resolved.pins.map { pin in
            let displayName = pin.identity
                .split(separator: "-")
                .map { $0.prefix(1).uppercased() + $0.dropFirst() }
                .joined(separator: " ")

            return Acknowledgment(
                name: displayName,
                licenseText: "",
                url: pin.location,
                licenseType: .unknown
            )
        }
    }

    // MARK: - Licenses/ Directory Scanning

    private func scanLicensesDirectory(in directory: String) -> [Acknowledgment] {
        let licensesURL = URL(fileURLWithPath: directory)
            .appendingPathComponent("Licenses")

        guard let contents = try? FileManager.default.contentsOfDirectory(
            at: licensesURL,
            includingPropertiesForKeys: nil
        ) else {
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

    // MARK: - Merging

    private func mergeEntries(
        resolvedEntries: [Acknowledgment],
        licenseEntries: [Acknowledgment]
    ) -> [Acknowledgment] {
        var entriesByName: [String: Acknowledgment] = [:]

        for entry in resolvedEntries {
            entriesByName[entry.name.lowercased()] = entry
        }

        for entry in licenseEntries {
            let key = entry.name.lowercased()
            if let existing = entriesByName[key] {
                entriesByName[key] = Acknowledgment(
                    name: existing.name,
                    licenseText: entry.licenseText,
                    url: existing.url.isEmpty ? entry.url : existing.url,
                    licenseType: entry.licenseType
                )
            } else {
                entriesByName[key] = entry
            }
        }

        return Array(entriesByName.values)
    }
}
