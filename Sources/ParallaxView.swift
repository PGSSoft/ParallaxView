//
//  ParallaxCollectionViewCell.swift
//  Jenkins
//
//  Created by Łukasz Śliwiński on 20/04/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import UIKit

public class ParallaxView: UIView {

    // MARK: Properties

    internal let glowEffect: UIImageView

    var glowEffectContainerView: UIView? {
        didSet {
            glowEffectContainerView?.layer.cornerRadius = layer.cornerRadius
            glowEffectContainerView?.clipsToBounds = true
            glowEffectContainerView?.addSubview(glowEffect)
            glowEffectContainerView?.opaque = true
            glowEffectContainerView?.layer.shouldRasterize = true
        }
    }

    var parallaxEffectView: UIView?

    /// Maximum deviation of the shadow relative to the center
    public var shadowPanDeviation = 15.0

    /**
     Property allow to customize parallax effect (pan, angles, etc.)

     - seealso:
     [ParallaxEffect.swift](ParallaxEffect.swift)

     */
    public var parallaxEffect = ParallaxMotionEffect()

    /// Alpha of the glow effect
    public var glowEffectAlpha = CGFloat(1.0) {
        didSet {
            glowEffect.alpha = glowEffectAlpha
        }
    }

    /// Corner radius for the cell
    public var cornerRadius = CGFloat(10) {
        didSet {
            layer.cornerRadius = cornerRadius
            glowEffectContainerView?.layer.cornerRadius = layer.cornerRadius
        }
    }

    // MARK: Initialization

    public override init(frame: CGRect) {
        self.glowEffect = ParallaxView.loadGlowImage()

        super.init(frame: frame)

        commonInit()
        setupUnfocusedState()
    }

    public required init?(coder aDecoder: NSCoder) {
        self.glowEffect = ParallaxView.loadGlowImage()

        super.init(coder: aDecoder)

        commonInit()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        setupUnfocusedState()
    }

    public override func canBecomeFocused() -> Bool {
        return true
    }

    // MARK: UIView

    public override func layoutSubviews() {
        super.layoutSubviews()

        let maxSize = max(bounds.width, bounds.height)
        // Make glow a litte bit bigger than cell
        glowEffect.frame = CGRect(x: 0, y: 0, width: maxSize*1.7, height: maxSize*1.7)
        // Position in the middle and under the top edge of the cell
        glowEffect.center = CGPoint(x: bounds.width/2, y: -glowEffect.frame.height*0.95)
    }

    // MARK: UIResponder

    public override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for press in presses {
            switch press.type {
            case .Select:
                UIView.animateWithDuration(0.1, animations: {
                    self.transform = CGAffineTransformMakeScale(0.95, 0.95)
                })
            default:
                super.pressesBegan(presses, withEvent: event)
            }
        }
    }

    public override func pressesCancelled(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for press in presses {
            switch press.type {
            case .Select:
                UIView.animateWithDuration(0.1, animations: {
                    if self.focused {
                        self.setupFocusedState()
                    } else {
                        self.setupUnfocusedState()
                    }
                })
            default:
                super.pressesCancelled(presses, withEvent: event)
            }
        }
    }

    public override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for press in presses {
            switch press.type {
            case .Select:
                UIView.animateWithDuration(0.2, animations: {
                    if self.focused {
                        self.transform = CGAffineTransformIdentity
                        self.setupFocusedState()
                    } else {
                        self.transform = CGAffineTransformIdentity
                        self.setupUnfocusedState()
                    }
                })
            default:
                super.pressesEnded(presses, withEvent: event)
            }
        }
    }

    public override func pressesChanged(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        super.pressesChanged(presses, withEvent: event)
    }

    // MARK: UIFocusEnvironment

    public override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)

        guard let nextFocusedView = context.nextFocusedView else { return }
        if nextFocusedView == self {
            // Add parallax effect to focused cell
            becomeFocusedUsingAnimationCoordinator(coordinator)
        } else {
            // Remove parallax effect
            resignFocusUsingAnimationCoordinator(coordinator)
        }
    }

    // MARK: Private

    internal func commonInit() {
        layer.cornerRadius = cornerRadius

        glowEffect.alpha = glowEffectAlpha

        layer.shouldRasterize = true
    }

    internal class func loadGlowImage() -> UIImageView {
        if case let bundle = NSBundle(forClass: self), let glowImage = UIImage(named: "gloweffect", inBundle: bundle, compatibleWithTraitCollection: nil) {
            return UIImageView(image: glowImage)
        } else {
            fatalError("Can't initialize gloweffect image")
        }
    }

    internal func addParallaxMotionEffects() {
        // Cell parallax effect
        let parallaxMotionEffect = parallaxEffect

        // Shadow effect
        let veriticalShadowEffect = UIInterpolatingMotionEffect(keyPath: "layer.shadowOffset.height", type: .TiltAlongVerticalAxis)
        veriticalShadowEffect.minimumRelativeValue = -shadowPanDeviation
        veriticalShadowEffect.maximumRelativeValue = shadowPanDeviation/2

        let horizontalShadowEffect = UIInterpolatingMotionEffect(keyPath: "layer.shadowOffset.width", type: .TiltAlongHorizontalAxis)
        horizontalShadowEffect.minimumRelativeValue = -shadowPanDeviation
        horizontalShadowEffect.maximumRelativeValue = shadowPanDeviation

        let motionGroup = UIMotionEffectGroup()
        motionGroup.motionEffects = [parallaxMotionEffect, veriticalShadowEffect, horizontalShadowEffect]

        parallaxEffectView?.addMotionEffect(motionGroup)

        // Glow effect
        let verticalGlowEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        verticalGlowEffect.minimumRelativeValue = -glowEffect.frame.height
        verticalGlowEffect.maximumRelativeValue = bounds.height+glowEffect.frame.height*1.1

        let horizontalGlowEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        horizontalGlowEffect.minimumRelativeValue = -bounds.width+glowEffect.frame.width/4
        horizontalGlowEffect.maximumRelativeValue = bounds.width-glowEffect.frame.width/4

        let glowMotionGroup = UIMotionEffectGroup()
        glowMotionGroup.motionEffects = [horizontalGlowEffect, verticalGlowEffect]

        glowEffect.addMotionEffect(glowMotionGroup)
    }

    internal func removeParallaxMotionEffects() {
        parallaxEffectView?.motionEffects.removeAll()
        glowEffect.motionEffects.removeAll()
    }

    internal func becomeFocusedUsingAnimationCoordinator(coordinator: UIFocusAnimationCoordinator) {
        beforeBecomeFocusedAnimation()

        coordinator.addCoordinatedAnimations({
            self.addParallaxMotionEffects()
            self.setupFocusedState()
            }, completion: nil)
    }

    internal func resignFocusUsingAnimationCoordinator(coordinator: UIFocusAnimationCoordinator) {
        beforeResignFocusAnimation()

        coordinator.addCoordinatedAnimations({
            self.removeParallaxMotionEffects()
            self.setupUnfocusedState()
            }, completion: nil)
    }

    // MARK: Public

    public func setupUnfocusedState() {}

    public func setupFocusedState() {}

    public func beforeBecomeFocusedAnimation() {}

    public func beforeResignFocusAnimation() {}

}
