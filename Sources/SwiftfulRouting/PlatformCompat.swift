//
//  PlatformCompat.swift
//  SwiftfulRouting
//
//  Cross-platform shims so SwiftfulRouting builds on macOS as well as iOS/tvOS.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Bounds of the main screen, resolved per-platform.
var platformScreenBounds: CGRect {
    #if canImport(UIKit)
    return UIScreen.main.bounds
    #elseif canImport(AppKit)
    return NSScreen.main?.frame ?? CGRect(x: 0, y: 0, width: 1280, height: 800)
    #else
    return CGRect(x: 0, y: 0, width: 1280, height: 800)
    #endif
}

/// Presents full-screen-cover destinations. macOS has no `fullScreenCover`, so it
/// falls back to `sheet` (the closest modal presentation).
struct FullScreenCoverPresenter: ViewModifier {
    let viewModel: RouterViewModel
    let routerId: String

    func body(content: Content) -> some View {
        let item = Binding(
            stack: viewModel.activeScreenStacks,
            routerId: routerId,
            segue: .fullScreenCover,
            isResizeableSheet: false,
            onDidDismiss: {
                // This triggers if the user swipes down to dismiss the screen.
                viewModel.dismissScreens(toEnvironmentId: routerId, animates: true)
            }
        )

        #if os(iOS) || os(tvOS)
        content.fullScreenCover(item: item, onDismiss: nil) { destination in
            destination.destination
                .applyResizableSheetModifiersIfNeeded(segue: destination.segue)
                .environmentObject(viewModel)
        }
        #else
        content.sheet(item: item, onDismiss: nil) { destination in
            destination.destination
                .applyResizableSheetModifiersIfNeeded(segue: destination.segue)
                .environmentObject(viewModel)
        }
        #endif
    }
}
