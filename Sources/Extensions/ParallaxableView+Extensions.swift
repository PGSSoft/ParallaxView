//
//  ParallaxableView+Extensions.swift
//  ParallaxView
//
//  Created by Łukasz Śliwiński on 20/06/16.
//
//

import UIKit

/// Actions for a parallax view
open class ParallaxViewActions<T: UIView> where T: ParallaxableView {

    /// Closure will be called in animation block by ParallaxableView when view should change its appearance to the focused state
    open var setupUnfocusedState: ((T) -> Void)?
    /// Closure will be called in animation block by ParallaxableView when view should change its appearance to the unfocused state
    open var setupFocusedState: ((T) -> Void)?
    /// Closure will be called by ParallaxableView before the animation to the focused state start
    open var beforeBecomeFocusedAnimation: ((T) -> Void)?
    /// Closure will be called by ParallaxableView before the animation to the unfocused state start
    open var beforeResignFocusAnimation: ((T) -> Void)?
    /// Closure will be called when didFocusChange happened. In most cases default implementation should work
    open var becomeFocused: ((T, _ context: UIFocusUpdateContext, _ animationCoordinator: UIFocusAnimationCoordinator) -> Void)?
    /// Closure will be called when didFocusChange happened. In most cases default implementation should work
    open var resignFocus: ((T, _ context: UIFocusUpdateContext, _ animationCoordinator: UIFocusAnimationCoordinator) -> Void)?
    /// Default implementation of the press begin animation for the ParallaxableView
    open var animatePressIn: ((T, _ presses: Set<UIPress>, _ event: UIPressesEvent?) -> Void)?
    /// Default implementation of the press ended animation for the ParallaxableView
    open var animatePressOut: ((T, _ presses: Set<UIPress>, _ event: UIPressesEvent?) -> Void)?

    /// Creates actions for parallax view with default behaviours
    public init() {
        becomeFocused = { [weak self] (view: T, context, coordinator) in
            self?.beforeBecomeFocusedAnimation?(view)

            if #available(tvOS 11.0, *) {
                coordinator.addCoordinatedFocusingAnimations(
                    { (context) in
                        self?.setupFocusedState?(view)
                        view.addParallaxMotionEffects(with: &view.parallaxEffectOptions)
                    },
                    completion: nil
                )
            } else {
                coordinator.addCoordinatedAnimations(
                    {
                        view.addParallaxMotionEffects(with: &view.parallaxEffectOptions)
                        self?.setupFocusedState?(view)
                    },
                    completion: nil
                )
            }
        }

        resignFocus = { [weak self] (view: T, context, coordinator) in
            self?.beforeResignFocusAnimation?(view)

            if #available(tvOS 11.0, *) {
                coordinator.addCoordinatedUnfocusingAnimations(
                    { (context) in
                        view.removeParallaxMotionEffects(with: view.parallaxEffectOptions)
                        self?.setupUnfocusedState?(view)
                    },
                    completion: nil
                )
            } else {
                coordinator.addCoordinatedAnimations(
                    {
                        view.removeParallaxMotionEffects(with: view.parallaxEffectOptions)
                        self?.setupUnfocusedState?(view)
                    },
                    completion: nil
                )
            }
        }

        animatePressIn = { (view: T, presses, event) in
            for press in presses {
                if case .select = press.type {
                    UIView.animate(
                        withDuration: 0.12,
                        animations: {
                            view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                        }
                    )
                }
            }
        }

        animatePressOut = { [weak self] (view: T, presses, event) in
            for press in presses {
                if case .select = press.type {
                    UIView.animate(
                        withDuration: 0.12,
                        animations: {
                            if view.isFocused {
                                view.transform = CGAffineTransform.identity
                                self?.setupFocusedState?(view)
                            } else {
                                view.transform = CGAffineTransform.identity
                                self?.setupUnfocusedState?(view)
                            }
                        }
                    )
                }
            }
        }
    }

}

extension ParallaxableView where Self: UIView {

    // MARK: Properties

    /// The corner radius for the parallax view and if applicable also applied to the glow effect
    public var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue

            // Change the glowEffectContainerView corner radius only if it is a direct subview of the parallax view
            if let glowEffectContainerView = parallaxEffectOptions.glowContainerView,
                self.subviews.contains(glowEffectContainerView)
            {
                glowEffectContainerView.layer.cornerRadius = newValue
            }
        }
    }

    // MARK: ParallaxableView

    /// Get the glow image view that can be used to create the glow effect
    /// - Returns: Image with radial gradient/shadow to imitate glow
    public func getGlowImageView() -> UIImageView? {
        return
            parallaxEffectOptions.glowContainerView?.subviews.filter({ (view) -> Bool in
                if let glowImageView = view as? UIImageView,
                    let glowImage = glowImageView.image,
                    glowImage.accessibilityIdentifier == glowImageAccessibilityIdentifier
                {
                    return true
                }
                return false
            }).first as? UIImageView
    }

}
