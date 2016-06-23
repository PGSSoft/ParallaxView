//
//  ParallaxableView+Extensions.swift
//  ParallaxView
//
//  Created by Łukasz Śliwiński on 20/06/16.
//
//

import UIKit

public class ParallaxViewActions<T: UIView where T:ParallaxableView> {

    /// Closure will be called in animation block by ParallaxableView when view should change its appearance to the focused state
    public var setupUnfocusedState: ((T) -> Void)?
    /// Closure will be called in animation block by ParallaxableView when view should change its appearance to the unfocused state
    public var setupFocusedState: ((T) -> Void)?
    /// Closure will be called by ParallaxableView before the animation to the focused change start
    public var beforeBecomeFocusedAnimation: ((T) -> Void)?
    /// Closure will be called by ParallaxableView before the animation to the unfocused change start
    public var beforeResignFocusAnimation: ((T) -> Void)?
    /// Closure will be called when didFocusChange happened. In most cases default implementation should work
    public var becomeFocused: ((T, context: UIFocusUpdateContext, animationCoordinator: UIFocusAnimationCoordinator) -> Void)?
    /// Closure will be called when didFocusChange happened. In most cases default implementation should work
    public var resignFocus: ((T, context: UIFocusUpdateContext, animationCoordinator: UIFocusAnimationCoordinator) -> Void)?
    /// Default implementation of the press begin animation for the ParallaxableView
    public var animatePressIn: ((T, presses: Set<UIPress>, event: UIPressesEvent?) -> Void)?
    /// Default implementation of the press ended animation for the ParallaxableView
    public var animatePressOut: ((T, presses: Set<UIPress>, event: UIPressesEvent?) -> Void)?

    init() {
        becomeFocused = { [weak self] (view: T, context, coordinator) in
            self?.beforeBecomeFocusedAnimation?(view)

            coordinator.addCoordinatedAnimations({
                view.addParallaxMotionEffects(with: &view.parallaxEffectOptions)
                self?.setupFocusedState?(view)
                }, completion: nil)
        }

        resignFocus = { [weak self] (view: T, context, coordinator) in
            self?.beforeResignFocusAnimation?(view)

            coordinator.addCoordinatedAnimations({
                view.removeParallaxMotionEffects(glowContainer: view.parallaxEffectOptions.glowContainerView)
                self?.setupUnfocusedState?(view)
                }, completion: nil)
        }

        animatePressIn = { (view: T, presses, event) in
            for press in presses {
                if case .Select = press.type {
                    UIView.animateWithDuration(0.12, animations: {
                        view.transform = CGAffineTransformMakeScale(0.95, 0.95)
                    })
                }
            }
        }

        animatePressOut = { [weak self] (view: T, presses, event) in
            for press in presses {
                if case .Select = press.type {
                    UIView.animateWithDuration(0.12, animations: {
                        if view.focused {
                            view.transform = CGAffineTransformIdentity
                            self?.setupFocusedState?(view)
                        } else {
                            view.transform = CGAffineTransformIdentity
                            self?.setupUnfocusedState?(view)
                        }
                    })
                }
            }
        }
    }

}

public extension ParallaxableView where Self: UIView {

    // MARK: Properties

    /// Configure radius for parallaxView and glow effect if needed
    public var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue

            // Change the glowEffectContainerView corner radius only if it is a direct subview of the parallax view
            if let glowEffectContainerView = parallaxEffectOptions.glowContainerView where self.subviews.contains(glowEffectContainerView) {
                glowEffectContainerView.layer.cornerRadius = newValue
            }
        }
    }

    // MARK: ParallaxableView

    /**
     Get glow image view that can be used to create glow effect

     - returns: Image with radial gradient/shadow to imitate glow
     */
    public func getGlowImageView() -> UIImageView? {
        return parallaxEffectOptions.glowContainerView?.subviews.filter({ (view) -> Bool in
            if let glowImageView = view as? UIImageView,
                glowImage = glowImageView.image where glowImage.accessibilityIdentifier == glowImageAccessibilityIdentifier {
                return true
            }
            return false
        }).first as? UIImageView
    }

}
