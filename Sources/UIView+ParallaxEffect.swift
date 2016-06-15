//
//  UIView+ParallaxEffect.swift
//  ParallaxView
//
//  Created by Łukasz Śliwiński on 15/06/16.
//
//

import UIKit

public extension UIView {

    private static let glowImageAccessibilityIdentifier = "com.pgs-soft.parallaxview.gloweffect"

    public static func createGlowImageView() -> UIImageView {
        if case let bundle = NSBundle(forClass: ParallaxView.self), let glowImage = UIImage(named: "gloweffect", inBundle: bundle, compatibleWithTraitCollection: nil) {
            glowImage.accessibilityIdentifier = UIView.glowImageAccessibilityIdentifier
            let imageView = UIImageView(image: glowImage)
            imageView.contentMode = .ScaleAspectFit

            return UIImageView(image: glowImage)
        } else {
            fatalError("Can't initialize gloweffect image")
        }
    }

    public func addParallaxMotionEffects(withOptions options: ParallaxEffectOptions = ParallaxEffectOptions()) {
        if options.glowContainerView == nil {
            options.glowContainerView = self
        }

        guard let glowContainerView = options.glowContainerView else { return }

        // Need to clip to bounds because of the glow effect
        glowContainerView.clipsToBounds = true

        // Configure glow image
        let glowImageView = UIView.createGlowImageView()
        glowImageView.alpha = CGFloat(options.glowAlpha)
        glowContainerView.addSubview(glowImageView)

        // Configure frame of the glow effect without animation
        UIView.performWithoutAnimation {
            let maxSize = max(glowContainerView.frame.width, glowContainerView.frame.height)*1.7
            // Make glow a litte bit bigger than the superview
            glowImageView.frame = CGRect(x: 0, y: 0, width: maxSize, height: maxSize)
            // Position in the middle and under the top edge of the superview
            glowImageView.center = CGPoint(x: glowContainerView.frame.width/2, y: -glowImageView.frame.height)
        }

        let motionGroup = UIMotionEffectGroup()
        motionGroup.motionEffects = []

        // Add parallax effect
        motionGroup.motionEffects?.append(options.parallaxMotionEffect)

        // Configure shadow pan motion effect
        if options.shadowPanDeviation != 0 {
            let veriticalShadowEffect = UIInterpolatingMotionEffect(keyPath: "layer.shadowOffset.height", type: .TiltAlongVerticalAxis)
            veriticalShadowEffect.minimumRelativeValue = -options.shadowPanDeviation
            veriticalShadowEffect.maximumRelativeValue = options.shadowPanDeviation/2

            let horizontalShadowEffect = UIInterpolatingMotionEffect(keyPath: "layer.shadowOffset.width", type: .TiltAlongHorizontalAxis)
            horizontalShadowEffect.minimumRelativeValue = -options.shadowPanDeviation
            horizontalShadowEffect.maximumRelativeValue = options.shadowPanDeviation

            motionGroup.motionEffects?.appendContentsOf([veriticalShadowEffect, horizontalShadowEffect])
        }

        addMotionEffect(motionGroup)

        // Configure pan motion effect for the subviews
        if case .None = options.subviewsParallaxType {
        } else {
            subviews
                .filter { $0 !== glowContainerView }
                .enumerate()
                .forEach { (index: Int, subview: UIView) in
                    let relativePanValue: Double

                    switch options.subviewsParallaxType {
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

        // Configure pan motion effect for the glow
        let verticalGlowEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        verticalGlowEffect.minimumRelativeValue = -glowImageView.frame.height * CGFloat(options.minVerticalPanGlowMultipler)
        verticalGlowEffect.maximumRelativeValue = glowImageView.frame.height * CGFloat(options.maxVerticalPanGlowMultipler)

        let horizontalGlowEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        horizontalGlowEffect.minimumRelativeValue = -bounds.width+glowImageView.frame.width/4
        horizontalGlowEffect.maximumRelativeValue = bounds.width-glowImageView.frame.width/4

        let glowMotionGroup = UIMotionEffectGroup()
        glowMotionGroup.motionEffects = [horizontalGlowEffect, verticalGlowEffect]

        glowImageView.addMotionEffect(glowMotionGroup)
    }

    public func removeParallaxMotionEffects(glowContainerView glowContainerView: UIView? = nil) {
        motionEffects.removeAll()
        subviews
            .filter { $0 !== glowContainerView }
            .forEach { (subview: UIView) in
                subview.motionEffects.removeAll()
        }

        guard let glowContainerView = glowContainerView else { return }

        if let glowImageView = glowContainerView.subviews.filter({
            if let glowImageView = $0 as? UIImageView,
                glowImage = glowImageView.image where glowImage.accessibilityIdentifier == UIView.glowImageAccessibilityIdentifier {
                return true
            }
            return false
        }).first {
            glowImageView.motionEffects.removeAll()
            glowImageView.removeFromSuperview()
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

    func getGlowImageView() -> UIImageView? {
        return parallaxEffectOptions.glowContainerView?.subviews.filter({ (view) -> Bool in
            if let glowImageView = view as? UIImageView,
                glowImage = glowImageView.image where glowImage.accessibilityIdentifier == UIView.glowImageAccessibilityIdentifier {
                return true
            }
            return false
        }).first as? UIImageView
    }

    func setupUnfocusedState() {}

    func setupFocusedState() {}

    func beforeBecomeFocusedAnimation() {}

    func beforeResignFocusAnimation() {}

    func becomeFocusedInContext(context: UIFocusUpdateContext, withAnimationCoordinator: UIFocusAnimationCoordinator) {
        beforeBecomeFocusedAnimation()

        withAnimationCoordinator.addCoordinatedAnimations({
            self.addParallaxMotionEffects(withOptions: self.parallaxEffectOptions)
            self.setupFocusedState()
            }, completion: nil)
    }

    func resignFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator: UIFocusAnimationCoordinator) {
        beforeResignFocusAnimation()

        withAnimationCoordinator.addCoordinatedAnimations({
            self.removeParallaxMotionEffects(glowContainerView: self.parallaxEffectOptions.glowContainerView)
            self.setupUnfocusedState()
            }, completion: nil)
    }

}
