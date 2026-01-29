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
    @MainActor public func showScreenWithZoomTransition<T>(
        _ style: SegueOption,
        id: String = UUID().uuidString,
        location: SegueLocation = .insert,
        animates: Bool = true,
        transitionBehavior: TransitionMemoryBehavior = .keepPrevious,
        onDismiss: (() -> Void)? = nil,
        transitionID: String? = nil,
        namespace: Namespace.ID,
        destination: @escaping (AnyRouter) -> T,
    ) where T : View {
        guard let transitionID = transitionID else {

            let destination = AnyDestination(id: id, segue: segue, location: location, animates: animates, transitionBehavior: transitionBehavior, onDismiss: onDismiss, destination: destination)
            object.showScreens(destinations: [destination])

            return
        }

        let view: View = ZoomTransitionDestinationView(transitionID: transitionID, namespace: namespace) {
            destination(router)
        }

        let destination = AnyDestination(id: id, segue: segue, location: location, animates: animates, transitionBehavior: transitionBehavior, onDismiss: onDismiss, destination: view)
        object.showScreens(destinations: [destination])
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
