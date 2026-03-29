// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "HavenAcknowledgments",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
    ],
    products: [
        .library(
            name: "HavenAcknowledgments",
            targets: ["HavenAcknowledgments"]
        ),
        .library(
            name: "HavenAcknowledgmentsCore",
            targets: ["HavenAcknowledgmentsCore"]
        ),
        .plugin(
            name: "HavenAcknowledgmentsPlugin",
            targets: ["HavenAcknowledgmentsPlugin"]
        ),
    ],
    targets: [
        .target(
            name: "HavenAcknowledgmentsCore"
        ),
        .target(
            name: "HavenAcknowledgments",
            dependencies: ["HavenAcknowledgmentsCore"],
            resources: [
                .process("Resources"),
            ]
        ),
        .executableTarget(
            name: "AcknowledgmentsGeneratorTool",
            dependencies: ["HavenAcknowledgmentsCore"]
        ),
        .plugin(
            name: "HavenAcknowledgmentsPlugin",
            capability: .buildTool(),
            dependencies: [
                .target(name: "AcknowledgmentsGeneratorTool"),
            ]
        ),
        .testTarget(
            name: "HavenAcknowledgmentsTests",
            dependencies: ["HavenAcknowledgments", "HavenAcknowledgmentsCore"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
