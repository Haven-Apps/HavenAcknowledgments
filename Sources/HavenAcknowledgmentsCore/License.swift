import Foundation

/// Represents common open-source license types.
public enum License: String, Codable, Sendable, CaseIterable, Identifiable {
    case mit = "MIT"
    case apache2 = "Apache-2.0"
    case gpl2 = "GPL-2.0"
    case gpl3 = "GPL-3.0"
    case lgpl2 = "LGPL-2.1"
    case lgpl3 = "LGPL-3.0"
    case agpl3 = "AGPL-3.0"
    case bsd2 = "BSD-2-Clause"
    case bsd3 = "BSD-3-Clause"
    case mpl2 = "MPL-2.0"
    case isc = "ISC"
    case zlib = "Zlib"
    case boostSoftware = "BSL-1.0"
    case creativeCommonsZero = "CC0-1.0"
    case creativeCommonsBy4 = "CC-BY-4.0"
    case creativeCommonsBySA4 = "CC-BY-SA-4.0"
    case eclipse2 = "EPL-2.0"
    case artistic2 = "Artistic-2.0"
    case wtfpl = "WTFPL"
    case unlicense = "Unlicense"
    case zeroBSD = "0BSD"
    case mit0 = "MIT-0"
    case postgreSQL = "PostgreSQL"
    case blueOak = "BlueOak-1.0.0"
    case custom = "Custom"
    case unknown = "Unknown"

    public var id: String { rawValue }

    /// A human-readable display name for the license.
    public var displayName: String {
        switch self {
        case .mit: return "MIT License"
        case .apache2: return "Apache License 2.0"
        case .gpl2: return "GNU General Public License v2.0"
        case .gpl3: return "GNU General Public License v3.0"
        case .lgpl2: return "GNU Lesser General Public License v2.1"
        case .lgpl3: return "GNU Lesser General Public License v3.0"
        case .agpl3: return "GNU Affero General Public License v3.0"
        case .bsd2: return "BSD 2-Clause License"
        case .bsd3: return "BSD 3-Clause License"
        case .mpl2: return "Mozilla Public License 2.0"
        case .isc: return "ISC License"
        case .zlib: return "zlib License"
        case .boostSoftware: return "Boost Software License 1.0"
        case .creativeCommonsZero: return "Creative Commons Zero v1.0 Universal"
        case .creativeCommonsBy4: return "Creative Commons Attribution 4.0"
        case .creativeCommonsBySA4: return "Creative Commons Attribution ShareAlike 4.0"
        case .eclipse2: return "Eclipse Public License 2.0"
        case .artistic2: return "Artistic License 2.0"
        case .wtfpl: return "Do What The F*ck You Want To Public License"
        case .unlicense: return "The Unlicense"
        case .zeroBSD: return "Zero-Clause BSD License"
        case .mit0: return "MIT No Attribution License"
        case .postgreSQL: return "PostgreSQL License"
        case .blueOak: return "Blue Oak Model License 1.0.0"
        case .custom: return "Custom License"
        case .unknown: return "Unknown License"
        }
    }

    /// Detects the license type from the full text of a license file.
    public static func detect(from text: String) -> License {
        let lowered = text.lowercased()

        // MIT
        if lowered.contains("mit license") || lowered.contains("permission is hereby granted, free of charge") {
            return .mit
        }

        // Apache
        if lowered.contains("apache license") {
            return .apache2
        }

        // AGPL (check before GPL to avoid false match)
        if lowered.contains("gnu affero general public license") {
            return .agpl3
        }

        // LGPL (check before GPL to avoid false match)
        if lowered.contains("gnu lesser general public license") {
            if lowered.contains("version 3") {
                return .lgpl3
            }
            return .lgpl2
        }

        // GPL
        if lowered.contains("gnu general public license") {
            if lowered.contains("version 2") {
                return .gpl2
            }
            return .gpl3
        }

        // BSD
        if lowered.contains("redistribution and use") {
            if lowered.contains("neither the name") || lowered.contains("the names of its contributors") {
                return .bsd3
            }
            return .bsd2
        }

        // MPL
        if lowered.contains("mozilla public license") {
            return .mpl2
        }

        // ISC
        if lowered.contains("isc license") || (lowered.contains("permission to use, copy, modify") && lowered.contains("isc")) {
            return .isc
        }

        // zlib
        if lowered.contains("zlib license") || (lowered.contains("not claim that you wrote the original software") && lowered.contains("altered source versions")) {
            return .zlib
        }

        // Boost
        if lowered.contains("boost software license") {
            return .boostSoftware
        }

        // Creative Commons
        if lowered.contains("creative commons") {
            if lowered.contains("cc0") || lowered.contains("public domain") {
                return .creativeCommonsZero
            } else if lowered.contains("sharealike") {
                return .creativeCommonsBySA4
            } else if lowered.contains("attribution") {
                return .creativeCommonsBy4
            }
        }

        // Eclipse
        if lowered.contains("eclipse public license") {
            return .eclipse2
        }

        // Artistic
        if lowered.contains("artistic license") {
            return .artistic2
        }

        // WTFPL
        if lowered.contains("do what the fuck you want to") || lowered.contains("wtfpl") {
            return .wtfpl
        }

        // Unlicense
        if lowered.contains("the unlicense") || lowered.contains("this is free and unencumbered") {
            return .unlicense
        }

        // Zero-Clause BSD
        if lowered.contains("zero-clause bsd") || lowered.contains("0-clause bsd") || lowered.contains("0bsd") {
            return .zeroBSD
        }

        // MIT No Attribution (check after MIT to avoid false match — but MIT is checked first above)
        if lowered.contains("mit no attribution") || lowered.contains("mit-0") {
            return .mit0
        }

        // PostgreSQL
        if lowered.contains("postgresql license") || lowered.contains("postgres95") {
            return .postgreSQL
        }

        // Blue Oak
        if lowered.contains("blue oak model license") {
            return .blueOak
        }

        return .custom
    }
}
