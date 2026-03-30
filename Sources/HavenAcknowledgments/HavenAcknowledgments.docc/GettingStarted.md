# Getting Started with HavenAcknowledgments

Add automatic license acknowledgments to your SwiftUI app in minutes.

## Overview

HavenAcknowledgments uses a build plugin to scan your dependencies and generate
a JSON manifest at build time. The SwiftUI views then load this manifest and
display it in a searchable, platform-adaptive interface.

### Step 1: Add the Package Dependency

Add HavenAcknowledgments to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Haven-Apps/HavenAcknowledgments.git", from: "1.0.0")
]
```

Or in Xcode, go to **File > Add Package Dependencies** and search for the
repository URL.

### Step 2: Apply the Build Plugin

Add both the library and the build plugin to your target:

```swift
.target(
    name: "MyApp",
    dependencies: ["HavenAcknowledgments"],
    plugins: [
        .plugin(name: "HavenAcknowledgmentsPlugin", package: "HavenAcknowledgments")
    ]
)
```

For Xcode projects, add the plugin under your target's
**Build Phases > Run Build Tool Plug-ins**.

### Step 3: Display the UI

The simplest approach is the sheet modifier:

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

Or embed the view directly in your navigation hierarchy:

```swift
HavenAcknowledgmentsView()
```

### Adding Manual Licenses

For dependencies that aren't managed by SPM (such as vendored code or CocoaPods
libraries), create a `Licenses/` directory at the root of your project. Place a
text file for each dependency, named after the library:

```
MyProject/
├── Licenses/
│   ├── SomeVendoredLib.txt
│   └── AnotherLib.txt
├── Package.swift
└── Sources/
```

The build plugin will automatically merge these with the auto-detected licenses.

### Custom Data Sources

If you need to load acknowledgments from a non-standard location (for example,
a remote server or a different bundle), conform to
``AcknowledgmentsManifestProvider``:

```swift
struct RemoteManifestProvider: AcknowledgmentsManifestProvider {
    let url: URL

    func loadManifest() async throws -> AcknowledgmentsManifest {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try AcknowledgmentsManifest.decode(from: data)
    }
}
```

Then pass your provider to any of the library's views:

```swift
HavenAcknowledgmentsView(provider: RemoteManifestProvider(url: myURL))
```

## Topics

### Views

- ``HavenAcknowledgmentsView``
- ``AcknowledgmentsNavigationView``
- ``AcknowledgmentsListView``
- ``LicenseDetailView``

### Data

- ``AcknowledgmentsManifestProvider``
- ``BundleManifestProvider``
- ``PreviewManifestProvider``
