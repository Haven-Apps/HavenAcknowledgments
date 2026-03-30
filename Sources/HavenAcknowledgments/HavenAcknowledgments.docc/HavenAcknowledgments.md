# ``HavenAcknowledgments``

Display third-party open-source license acknowledgments in your app with a single line of SwiftUI.

@Metadata {
    @DisplayName("HavenAcknowledgments")
}

## Overview

HavenAcknowledgments is a SwiftUI library that automatically collects license
information from your Swift Package Manager dependencies and presents them in a
polished, searchable interface. It consists of three parts:

- A **build plugin** that scans your `Package.resolved` and reads license files
  from SPM checkouts at build time.
- A **core module** (``HavenAcknowledgmentsCore``) with the shared data models.
- A **SwiftUI module** with ready-to-use views and a sheet modifier.

### Quick Start

Add the package to your project, then apply the build plugin and display the UI:

```swift
// Package.swift
.target(
    name: "MyApp",
    dependencies: ["HavenAcknowledgments"],
    plugins: [
        .plugin(name: "HavenAcknowledgmentsPlugin", package: "HavenAcknowledgments")
    ]
)
```

```swift
// In your SwiftUI view
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

Or embed the view directly:

```swift
HavenAcknowledgmentsView()
```

## Topics

### Essentials

- <doc:GettingStarted>
- ``HavenAcknowledgmentsView``

### Presenting Acknowledgments

- ``AcknowledgmentsNavigationView``
- ``AcknowledgmentsSheetModifier``
- ``AcknowledgmentsListView``
- ``LicenseDetailView``

### Loading Data

- ``AcknowledgmentsManifestProvider``
- ``BundleManifestProvider``
- ``AcknowledgmentsLoader``
- ``AcknowledgmentsLoadError``

### Utilities

- ``AcknowledgmentsBundleAccessor``
- ``AcknowledgmentsPreviewData``
- ``PreviewManifestProvider``
