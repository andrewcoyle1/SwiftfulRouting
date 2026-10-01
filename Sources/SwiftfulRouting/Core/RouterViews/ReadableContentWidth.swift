//
//  ReadableContentWidth.swift
//  SwiftfulRouting
//
import SwiftUI

public struct ReadableContentWidthKey: EnvironmentKey {
    public static let defaultValue: CGFloat? = nil
}

public extension EnvironmentValues {
    /// When set, every routed screen wider than this centres its content in a column of this width,
    /// by padding its horizontal safe area. Backgrounds and anything ignoring the safe area stay
    /// full-bleed. Each screen measures itself, so a sheet is not squeezed by its wider presenter.
    var readableContentWidth: CGFloat? {
        get { self[ReadableContentWidthKey.self] }
        set { self[ReadableContentWidthKey.self] = newValue }
    }
}

struct ReadableContentMargins: ViewModifier {

    @Environment(\.readableContentWidth) private var maxWidth
    @State private var width: CGFloat = 0

    private var margin: CGFloat {
        guard let maxWidth, width > maxWidth else { return 0 }
        return (width - maxWidth) / 2
    }

    func body(content: Content) -> some View {
        if #available(iOS 17, macOS 14, tvOS 17, *) {
            content
                .safeAreaPadding(.horizontal, margin)
                .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { width = $0 }
        } else {
            content
        }
    }
}
