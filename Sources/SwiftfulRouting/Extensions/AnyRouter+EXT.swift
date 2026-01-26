//
//  AnyRouter+EXT.swift
//  SwiftfulRouting
//
//  Created by Andrew Coyle on 26/01/2026.
//

import SwiftUI

extension AnyRouter {
    /// Shows a screen with an optional zoom transition.
    /// - Parameters:
    ///   - style: The presentation style (e.g., .sheet, .fullScreenCover)
    ///   - transitionID: Optional transition ID. If provided, a zoom transition will be used from a button with matching ID.
    ///   - namespace: The namespace to use for the transition
    ///   - content: The view builder for the destination content
    @MainActor public func showScreenWithZoomTransition<Content: View>(
        _ style: SegueOption,
        transitionID: String? = nil,
        namespace: Namespace.ID,
        @ViewBuilder content: @escaping (AnyRouter) -> Content
    ) {
        guard let transitionID = transitionID else {
            // No transition, use normal presentation
            showScreen(style) { router in
                content(router)
            }
            return
        }

        showScreen(style) { router in
            ZoomTransitionDestinationView(transitionID: transitionID, namespace: namespace) {
                content(router)
            }
        }
    }
}

// MARK: - Zoom Transition Support Views

/// A view that applies zoom transition to destination content.
private struct ZoomTransitionDestinationView<Content: View>: View {
    let transitionID: String
    let namespace: Namespace.ID
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZoomTransitionWrapper(transitionID: transitionID, namespace: namespace) {
            content()
        }
    }
}
