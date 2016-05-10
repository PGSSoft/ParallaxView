//
//  ParallaxView+Extensions.swift
//  Pods
//
//  Created by Łukasz Śliwiński on 10/05/16.
//
//

import UIKit

public extension ParallaxableView {

    func setupUnfocusedState() {}

    func setupFocusedState() {}

    func beforeBecomeFocusedAnimation() {}

    func beforeResignFocusAnimation() {}

    public var glowEffectAlpha: CGFloat {
        get {
            return glowEffect.alpha
        }
        set {
            glowEffect.alpha = newValue
        }
    }

    public var cornerRadius: CGFloat {
        get {
            return parallaxContainerView.layer.cornerRadius
        }
        set {
            parallaxContainerView.layer.cornerRadius = newValue
            glowEffectContainerView?.layer.cornerRadius = newValue
        }
    }

    func becomeFocusedUsingAnimationCoordinator(coordinator: UIFocusAnimationCoordinator) {
        beforeBecomeFocusedAnimation()

        coordinator.addCoordinatedAnimations({
            self.addParallaxMotionEffects()
            self.setupFocusedState()
            }, completion: nil)
    }

    func resignFocusUsingAnimationCoordinator(coordinator: UIFocusAnimationCoordinator) {
        beforeResignFocusAnimation()

        coordinator.addCoordinatedAnimations({
            self.removeParallaxMotionEffects()
            self.setupUnfocusedState()
            }, completion: nil)
    }

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

        parallaxContainerView.addMotionEffect(motionGroup)
        if case .None = subviewsParallaxType {
        } else {
            parallaxContainerView.subviews
                .filter { $0 !== glowEffectContainerView }
                .enumerate()
                .forEach { (index: Int, subview: UIView) in
                    let relativePanValue: Double

                    switch subviewsParallaxType {
                    case .BasedOnHierarchyInParallaxView(let maxOffset):
                        relativePanValue = maxOffset / (Double(index+1))
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
        verticalGlowEffect.minimumRelativeValue = -glowEffect.frame.height
        verticalGlowEffect.maximumRelativeValue = parallaxContainerView.bounds.height+glowEffect.frame.height*1.1

        let horizontalGlowEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        horizontalGlowEffect.minimumRelativeValue = -parallaxContainerView.bounds.width+glowEffect.frame.width/4
        horizontalGlowEffect.maximumRelativeValue = parallaxContainerView.bounds.width-glowEffect.frame.width/4

        let glowMotionGroup = UIMotionEffectGroup()
        glowMotionGroup.motionEffects = [horizontalGlowEffect, verticalGlowEffect]

        glowEffect.addMotionEffect(glowMotionGroup)
    }

    func removeParallaxMotionEffects() {
        parallaxContainerView.motionEffects.removeAll()
        parallaxContainerView.subviews
            .filter { $0 !== glowEffectContainerView }
            .forEach { (subview: UIView) in
                subview.motionEffects.removeAll()
        }
        glowEffect.motionEffects.removeAll()
    }

    static func loadGlowImage() -> UIImageView {
        if case let bundle = NSBundle(forClass: ParallaxView.self), let glowImage = UIImage(named: "gloweffect", inBundle: bundle, compatibleWithTraitCollection: nil) {
            return UIImageView(image: glowImage)
        } else {
            fatalError("Can't initialize gloweffect image")
        }
    }

}
