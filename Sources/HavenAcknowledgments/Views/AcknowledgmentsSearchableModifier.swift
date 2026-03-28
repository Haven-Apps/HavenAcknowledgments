import SwiftUI

/// A view modifier that presents acknowledgments in a sheet triggered by the modified view.
public struct AcknowledgmentsSheetModifier: ViewModifier {
    @Binding var isPresented: Bool
    private let provider: AcknowledgmentsManifestProvider

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
    /// Presents an acknowledgments sheet when `isPresented` is `true`.
    public func acknowledgmentsSheet(
        isPresented: Binding<Bool>,
        provider: AcknowledgmentsManifestProvider = BundleManifestProvider()
    ) -> some View {
        modifier(AcknowledgmentsSheetModifier(isPresented: isPresented, provider: provider))
    }
}
