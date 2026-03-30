//
//  AcknowledgmentsSearchableModifier.swift
//  HavenAcknowledgments
//
//  Created by HavenApps on 2026-03-28.
//  BSD-3 License see LICENSE.md
//

import SwiftUI

/// A view modifier that presents the acknowledgments UI in a modal sheet.
///
/// Apply this modifier through the convenience method
/// ``SwiftUICore/View/acknowledgmentsSheet(isPresented:provider:)``
/// rather than using it directly.
public struct AcknowledgmentsSheetModifier: ViewModifier {
    @Binding var isPresented: Bool
    private let provider: AcknowledgmentsManifestProvider

    /// Creates the sheet modifier.
    ///
    /// - Parameters:
    ///   - isPresented: A binding that controls whether the sheet is shown.
    ///   - provider: The manifest provider. Defaults to ``BundleManifestProvider``.
    public init(isPresented: Binding<Bool>, provider: AcknowledgmentsManifestProvider = BundleManifestProvider()) {
        _isPresented = isPresented
        self.provider = provider
    }

    public func body(content: Content) -> some View {
        content.sheet(isPresented: $isPresented) {
            AcknowledgmentsNavigationView(provider: provider)
                #if os(iOS)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
                #endif
        }
    }
}

extension View {
    /// Presents the acknowledgments UI in a sheet.
    ///
    /// ```swift
    /// @State private var showAcknowledgments = false
    ///
    /// var body: some View {
    ///     Button("Acknowledgments") {
    ///         showAcknowledgments = true
    ///     }
    ///     .acknowledgmentsSheet(isPresented: $showAcknowledgments)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: A binding that controls whether the sheet is shown.
    ///   - provider: The manifest provider. Defaults to ``BundleManifestProvider``.
    /// - Returns: A view with the acknowledgments sheet attached.
    public func acknowledgmentsSheet(
        isPresented: Binding<Bool>,
        provider: AcknowledgmentsManifestProvider = BundleManifestProvider()
    ) -> some View {
        modifier(AcknowledgmentsSheetModifier(isPresented: isPresented, provider: provider))
    }
}
