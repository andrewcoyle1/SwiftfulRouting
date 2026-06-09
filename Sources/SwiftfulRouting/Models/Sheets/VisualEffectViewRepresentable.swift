//
//  UIIntensityVisualEffectViewRepresentable.swift
//  SwiftfulRouting
//
//  Created by Nick Sarno on 4/19/25.
//
import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit

struct UIIntensityVisualEffectViewRepresentable: UIViewRepresentable {

    let effect: UIVisualEffect
    let intensity: CGFloat

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        IntensityVisualEffectView(effect: effect, intensity: intensity)
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {

    }

}

extension Animation {

    var asUIViewAnimationCurve: UIView.AnimationCurve {
        switch self {
        case .easeInOut:
            return .easeInOut
        default:
            return .linear
        }
    }
}

final class IntensityVisualEffectView: UIVisualEffectView {

    private var animator: UIViewPropertyAnimator!

    init(effect: UIVisualEffect?, intensity: CGFloat) {
        super.init(effect: nil)

        animator = UIViewPropertyAnimator(
            duration: ModalSupportView.backgroundAnimationDuration,
            curve: ModalSupportView.backgroundAnimationCurve.asUIViewAnimationCurve,
            animations: { [weak self] in
                self?.effect = effect
            }
        )
        animator.pausesOnCompletion = true
        animator.fractionComplete = intensity
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public struct BackgroundEffect {
    let effect: UIVisualEffect
    let intensity: CGFloat

    public init(effect: UIVisualEffect, intensity: CGFloat) {
        self.effect = effect
        self.intensity = intensity
    }
}

#else

/// macOS has no `UIVisualEffect`; modal background blur falls back to a SwiftUI
/// material in `ModalSupportView`. `BackgroundEffect` keeps only the intensity.
public struct BackgroundEffect {
    let intensity: CGFloat

    public init(intensity: CGFloat = 1) {
        self.intensity = intensity
    }
}

#endif
