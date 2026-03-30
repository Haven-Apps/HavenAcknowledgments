//
//  AcknowledgmentsPreviewData.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import Foundation
import HavenAcknowledgmentsCore

/// Sample data for SwiftUI previews and testing.
public enum AcknowledgmentsPreviewData {

    /// A sample set of acknowledgments for use in previews.
    public static let sampleAcknowledgments: [Acknowledgment] = [
        Acknowledgment(
            name: "Alamofire",
            licenseText: sampleMITLicense(holder: "Alamofire Software Foundation"),
            url: "https://github.com/Alamofire/Alamofire",
            licenseType: .mit
        ),
        Acknowledgment(
            name: "SwiftProtobuf",
            licenseText: sampleApacheLicense(holder: "Apple Inc."),
            url: "https://github.com/apple/swift-protobuf",
            licenseType: .apache2
        ),
        Acknowledgment(
            name: "Kingfisher",
            licenseText: sampleMITLicense(holder: "Wei Wang"),
            url: "https://github.com/onevcat/Kingfisher",
            licenseType: .mit
        ),
        Acknowledgment(
            name: "SnapKit",
            licenseText: sampleMITLicense(holder: "SnapKit Team"),
            url: "https://github.com/SnapKit/SnapKit",
            licenseType: .mit
        ),
        Acknowledgment(
            name: "SwiftyJSON",
            licenseText: sampleMITLicense(holder: "Ruoyu Fu"),
            url: "https://github.com/SwiftyJSON/SwiftyJSON",
            licenseType: .mit
        ),
    ]

    /// A sample manifest wrapping the sample acknowledgments.
    public static let sampleManifest = AcknowledgmentsManifest(
        acknowledgments: sampleAcknowledgments
    )

    private static func sampleMITLicense(holder: String) -> String {
        """
        MIT License

        Copyright (c) 2024 \(holder)

        Permission is hereby granted, free of charge, to any person obtaining a copy \
        of this software and associated documentation files (the "Software"), to deal \
        in the Software without restriction, including without limitation the rights \
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell \
        copies of the Software, and to permit persons to whom the Software is \
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all \
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR \
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, \
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE \
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER \
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, \
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE \
        SOFTWARE.
        """
    }

    private static func sampleApacheLicense(holder: String) -> String {
        """
        Apache License
        Version 2.0, January 2004

        Copyright \(holder)

        Licensed under the Apache License, Version 2.0 (the "License"); \
        you may not use this file except in compliance with the License. \
        You may obtain a copy of the License at

            http://www.apache.org/licenses/LICENSE-2.0

        Unless required by applicable law or agreed to in writing, software \
        distributed under the License is distributed on an "AS IS" BASIS, \
        WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. \
        See the License for the specific language governing permissions and \
        limitations under the License.
        """
    }
}
