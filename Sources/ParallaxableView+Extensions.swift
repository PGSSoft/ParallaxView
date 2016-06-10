//
//  ParallaxView+Extensions.swift
//
//  Created by Łukasz Śliwiński on 10/05/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import UIKit

public extension ParallaxableView where Self: UIView {

    // MARK: Properties

    /// Configure opacity of the parallax glow effect
    public var glowEffectAlpha: CGFloat {
        get {
            return glowEffect.alpha
        }
        set {
            glowEffect.alpha = newValue
        }
    }

    /// Configure radius for parallaxView and glow effect if needed
    public var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue

            // Change the glowEffectContainerView corner radius only if it is a direct subview of the parallax view
            if let glowEffectContainerView = glowEffectContainerView where self.subviews.contains(glowEffectContainerView) {
                glowEffectContainerView.layer.cornerRadius = newValue
            }
        }
    }

    // MARK: Convenience

    func addParallaxMotionEffects() {
        let motionGroup = UIMotionEffectGroup()
        motionGroup.motionEffects = []

        // Cell parallax effect
        let parallaxMotionEffect = parallaxEffect

        motionGroup.motionEffects?.append(parallaxMotionEffect)

        if shadowPanDeviation != 0 {
            // Shadow effect
            let veriticalShadowEffect = UIInterpolatingMotionEffect(keyPath: "layer.shadowOffset.height", type: .TiltAlongVerticalAxis)
            veriticalShadowEffect.minimumRelativeValue = -shadowPanDeviation
            veriticalShadowEffect.maximumRelativeValue = shadowPanDeviation/2

            let horizontalShadowEffect = UIInterpolatingMotionEffect(keyPath: "layer.shadowOffset.width", type: .TiltAlongHorizontalAxis)
            horizontalShadowEffect.minimumRelativeValue = -shadowPanDeviation
            horizontalShadowEffect.maximumRelativeValue = shadowPanDeviation

            motionGroup.motionEffects?.appendContentsOf([veriticalShadowEffect, horizontalShadowEffect])
        }

        addMotionEffect(motionGroup)
        if case .None = subviewsParallaxType {
        } else {
            subviews
                .filter { $0 !== glowEffectContainerView }
                .enumerate()
                .forEach { (index: Int, subview: UIView) in
                    let relativePanValue: Double

                    switch subviewsParallaxType {
                    case .BasedOnHierarchyInParallaxView(let maxOffset, let multipler):
                        relativePanValue = maxOffset / (Double(index+1)) * (multipler ?? 1.0)
                    case .BasedOnTag:
                        relativePanValue = Double(subview.tag)
                    default:
                        relativePanValue = 0.0
                    }

                    let verticalSubviewEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
                    verticalSubviewEffect.minimumRelativeValue = -relativePanValue
                    verticalSubviewEffect.maximumRelativeValue = relativePanValue

                    let horizontalSubviewEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
                    horizontalSubviewEffect.minimumRelativeValue = -relativePanValue
                    horizontalSubviewEffect.maximumRelativeValue = relativePanValue

                    let group = UIMotionEffectGroup()
                    group.motionEffects = [verticalSubviewEffect, horizontalSubviewEffect]
                    subview.addMotionEffect(group)
            }
        }

        // Glow effect
        let verticalGlowEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        verticalGlowEffect.minimumRelativeValue = -glowEffect.frame.height * CGFloat(minVerticalGlowEffectMultipler)
        verticalGlowEffect.maximumRelativeValue = glowEffect.frame.height * CGFloat(maxVerticalGlowEffectMultipler)

        let horizontalGlowEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        horizontalGlowEffect.minimumRelativeValue = -bounds.width+glowEffect.frame.width/4
        horizontalGlowEffect.maximumRelativeValue = bounds.width-glowEffect.frame.width/4

        let glowMotionGroup = UIMotionEffectGroup()
        glowMotionGroup.motionEffects = [horizontalGlowEffect, verticalGlowEffect]

        glowEffect.addMotionEffect(glowMotionGroup)
    }

    func removeParallaxMotionEffects() {
        motionEffects.removeAll()
        subviews
            .filter { $0 !== glowEffectContainerView }
            .forEach { (subview: UIView) in
                subview.motionEffects.removeAll()
        }
        glowEffect.motionEffects.removeAll()
    }

    // MARK: ParallaxableView

    func setupUnfocusedState() {}

    func setupFocusedState() {}

    func beforeBecomeFocusedAnimation() {}

    func beforeResignFocusAnimation() {}

    func becomeFocusedInContext(context: UIFocusUpdateContext, withAnimationCoordinator: UIFocusAnimationCoordinator) {
        beforeBecomeFocusedAnimation()

        withAnimationCoordinator.addCoordinatedAnimations({
            self.addParallaxMotionEffects()
            self.setupFocusedState()
            }, completion: nil)
    }

    func resignFocusedInContext(context: UIFocusUpdateContext, withAnimationCoordinator: UIFocusAnimationCoordinator) {
        beforeResignFocusAnimation()

        withAnimationCoordinator.addCoordinatedAnimations({
            self.removeParallaxMotionEffects()
            self.setupUnfocusedState()
            }, completion: nil)
    }

    // MARK: Static methods

    static func loadGlowImage() -> UIImageView {
        if case let bundle = NSBundle(forClass: ParallaxView.self), let glowImage = UIImage(named: "gloweffect", inBundle: bundle, compatibleWithTraitCollection: nil) {
            let imageView = UIImageView(image: glowImage)
            imageView.contentMode = .ScaleAspectFit

            return UIImageView(image: glowImage)
        } else {
            fatalError("Can't initialize gloweffect image")
        }
    }

}
