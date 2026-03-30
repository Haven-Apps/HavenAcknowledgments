# HavenAcknowledgments

A SwiftUI library that automatically generates and displays third-party license acknowledgments for Swift packages.

## Features

- **Automatic scanning** — reads `Package.resolved` and LICENSE files from package checkouts at build time
- **25+ license types** — detects MIT, Apache 2.0, BSD, GPL, LGPL, MPL, Creative Commons, and more via [SPDX](https://spdx.org/licenses/) identifiers
- **Ready-to-use UI** — searchable, platform-adaptive SwiftUI views with Markdown license rendering
- **Platform native** — `NavigationSplitView` on macOS, `NavigationStack` on iOS
- **Manual licenses** — include vendored or non-SPM dependencies via a `Licenses/` directory
- **SPM & Xcode** — works with both Swift Package Manager and Xcode project files
- **Swift 6 concurrency** — strict `Sendable` conformance and `@Observable` data loading
- **Localized** — ships with localized strings for all UI text

## Requirements

| | Minimum |
|---|---|
| iOS | 26+ |
| macOS | 26+ |
| Swift | 6.3+ |
| Xcode | 26+ |

## Installation

### Swift Package Manager

Add HavenAcknowledgments as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Haven-Apps/HavenAcknowledgments.git", from: "1.0.0")
]
```

Then add the library **and** the build plugin to your target:

```swift
.target(
    name: "MyApp",
    dependencies: ["HavenAcknowledgments"],
    plugins: [
        .plugin(name: "HavenAcknowledgmentsPlugin", package: "HavenAcknowledgments")
    ]
)
```

### Xcode

1. Go to **File > Add Package Dependencies** and enter the repository URL.
2. Add `HavenAcknowledgments` to your target's **Frameworks, Libraries, and Embedded Content**.
3. Add `HavenAcknowledgmentsPlugin` under **Build Phases > Run Build Tool Plug-ins**.

## Usage

### Display as a View

Drop `HavenAcknowledgmentsView` into any SwiftUI hierarchy:

```swift
import HavenAcknowledgments

struct SettingsView: View {
    var body: some View {
        HavenAcknowledgmentsView()
    }
}
```

### Present as a Sheet

Use the `.acknowledgmentsSheet(isPresented:)` modifier for modal presentation:

```swift
import HavenAcknowledgments

struct SettingsView: View {
    @State private var showAcknowledgments = false

    var body: some View {
        Button("Acknowledgments") {
            showAcknowledgments = true
        }
        .acknowledgmentsSheet(isPresented: $showAcknowledgments)
    }
}
```

### Custom Data Sources

Load acknowledgments from a non-standard location by conforming to `AcknowledgmentsManifestProvider`:

```swift
struct RemoteManifestProvider: AcknowledgmentsManifestProvider {
    let url: URL

    func loadManifest() async throws -> AcknowledgmentsManifest {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try AcknowledgmentsManifest.decode(from: data)
    }
}

// Then pass it to any view:
HavenAcknowledgmentsView(provider: RemoteManifestProvider(url: myURL))
```

## How It Works

The **build plugin** runs at build time and:

1. Parses your project's `Package.resolved` to discover all dependencies
2. Locates SPM package checkouts (via `.build/checkouts/` or Xcode's DerivedData)
3. Reads each package's LICENSE file and detects the license type
4. Merges any manual entries from a `Licenses/` directory in your project root
5. Outputs an `Acknowledgments.json` manifest as a build resource

At runtime, `HavenAcknowledgmentsView` loads this manifest and displays a searchable, navigable list of all acknowledged packages with their full license text.

## Manual Licenses

To include licenses for dependencies that aren't managed by SPM (such as vendored code or CocoaPods libraries), create a `Licenses/` directory at the root of your project:

```
MyProject/
├── Licenses/
│   ├── SomeVendoredLib.txt
│   └── AnotherDependency.txt
├── Package.swift
└── Sources/
```

The generator detects the license type from each file's contents and merges them into the manifest. Entries are deduplicated by name against auto-detected packages.

## Architecture

| Module | Purpose |
|---|---|
| `HavenAcknowledgmentsCore` | Shared models — `Acknowledgment`, `License`, `AcknowledgmentsManifest` |
| `HavenAcknowledgments` | SwiftUI views, data loading, and public API |
| `AcknowledgmentsGeneratorTool` | Build-time executable that scans dependencies and produces the JSON manifest |
| `HavenAcknowledgmentsPlugin` | SPM/Xcode build tool plugin that invokes the generator |

## Documentation

Full API documentation is available as a [DocC](https://developer.apple.com/documentation/docc) catalog bundled with the package. Build documentation in Xcode via **Product > Build Documentation**.

## License

HavenAcknowledgments is available under the BSD 3-Clause License. See [LICENSE.md](LICENSE.md) for details.
