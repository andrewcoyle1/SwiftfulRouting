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

struct PreferredReadableContentWidthKey: PreferenceKey {
    static let defaultValue: CGFloat? = nil
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = value ?? nextValue()
    }
}

public extension View {
    /// A screen's own column width, in place of `readableContentWidth`: wider for a dashboard that
    /// lays out in columns. No effect unless `readableContentWidth` is set.
    func preferredReadableContentWidth(_ width: CGFloat) -> some View {
        preference(key: PreferredReadableContentWidthKey.self, value: width)
    }
}

struct ReadableContentMargins: ViewModifier {

    @Environment(\.readableContentWidth) private var defaultWidth
    @State private var preferredWidth: CGFloat?
    @State private var width: CGFloat = 0

    private var margin: CGFloat {
        guard let defaultWidth else { return 0 }
        let maxWidth = preferredWidth ?? defaultWidth
        guard width > maxWidth else { return 0 }
        return (width - maxWidth) / 2
    }

    func body(content: Content) -> some View {
        if #available(iOS 17, macOS 14, tvOS 17, *) {
            content
                .safeAreaPadding(.horizontal, margin)
                .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { width = $0 }
                .onPreferenceChange(PreferredReadableContentWidthKey.self) { preferredWidth = $0 }
        } else {
            content
        }
    }
}
