# HavenAcknowledgments

A SwiftUI library that automatically generates and displays third-party license acknowledgments for Swift packages.

## Features

- Automatically scans `Package.resolved` and reads LICENSE files from package checkouts
- Detects 25+ common license types (MIT, Apache 2.0, BSD, GPL, and more)
- Provides a ready-to-use SwiftUI view with search, navigation, and detail display
- Uses `NavigationSplitView` on macOS and `NavigationStack` on iOS
- Supports manually provided licenses via a `Licenses/` directory
- Works with both SPM packages and Xcode projects
- Localized and built with Swift 6 strict concurrency

## Requirements

- iOS 26+ / macOS 26+
- Swift 6.3+
- Xcode 26+

## Installation

Add HavenAcknowledgments as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Haven-Apps/HavenAcknowledgments.git", from: "1.0.0")
]
```

Then add the library and the build plugin to your target:

```swift
.target(
    name: "MyApp",
    dependencies: ["HavenAcknowledgments"],
    plugins: ["HavenAcknowledgmentsPlugin"]
)
```

## Usage

### Display as a view

```swift
import HavenAcknowledgments

struct SettingsView: View {
    var body: some View {
        HavenAcknowledgmentsView()
    }
}
```

### Present as a sheet

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

## How It Works

The **build plugin** runs at build time and:

1. Parses your project's `Package.resolved` to discover all dependencies
2. Locates SPM package checkouts (via `.build/checkouts/` or Xcode's DerivedData)
3. Reads each package's LICENSE file and detects the license type
4. Merges any manual entries from a `Licenses/` directory in your project root
5. Outputs an `Acknowledgments.json` manifest as a build resource

At runtime, `HavenAcknowledgmentsView` loads this manifest and displays a searchable, navigable list of all acknowledged packages with their full license text.

## Manual Licenses

To include licenses for dependencies that aren't Swift packages (or to override detected licenses), create a `Licenses/` directory in your project root. Add one text file per entry, named after the dependency:

```
Licenses/
  SomeLibrary.txt
  AnotherDependency.txt
```

The generator will detect the license type from the file contents and merge these entries into the manifest.

## Architecture

| Module | Purpose |
|---|---|
| `HavenAcknowledgmentsCore` | Shared models (`Acknowledgment`, `License`, `AcknowledgmentsManifest`) |
| `HavenAcknowledgments` | SwiftUI views, data loading, and public API |
| `AcknowledgmentsGeneratorTool` | Build-time executable that produces the JSON manifest |
| `HavenAcknowledgmentsPlugin` | SPM build tool plugin that invokes the generator |
