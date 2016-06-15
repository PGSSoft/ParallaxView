//
//  ParallaxCollectionViewCell.swift
//
//  Created by Łukasz Śliwiński on 20/04/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import UIKit

public class ParallaxCollectionViewCell: UICollectionViewCell, ParallaxableView {

    // MARK: Properties

    public var parallaxEffectOptions = ParallaxEffectOptions()

    /// Disable animations for `pressesBegan`, `pressesCancelled`, `pressesEnded`, `pressesChanged`.
    /// If you want to customize those animations override listed methods.
    public var disablePressAnimations: Bool = false

    // MARK: Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
        setupUnfocusedState()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
        setupUnfocusedState()
    }

    internal func commonInit() {
        layer.shadowOpacity = 0.0
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.35
        layer.shouldRasterize = true

        if parallaxEffectOptions.glowContainerView == nil {
            parallaxEffectOptions.glowContainerView = contentView
        }
    }

    // MARK: UIView

    public override func canBecomeFocused() -> Bool {
        return true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        guard let glowEffectContainerView = parallaxEffectOptions.glowContainerView else { return }

        if glowEffectContainerView != self, let glowSuperView = glowEffectContainerView.superview {
            glowEffectContainerView.frame = glowSuperView.bounds
        }

        let maxSize = max(glowEffectContainerView.frame.width, glowEffectContainerView.frame.height)*1.7
        // Make glow a litte bit bigger than the superview

        guard let glowImageView = getGlowImageView() else { return }

        glowImageView.frame = CGRect(x: 0, y: 0, width: maxSize, height: maxSize)
        // Position in the middle and under the top edge of the superview
        glowImageView.center = CGPoint(x: glowEffectContainerView.frame.width/2, y: -glowImageView.frame.height)
    }

    // MARK: UIResponder

    // Generally, all responders which do custom touch handling should override all four of these methods.
    // If you want to customize animations for press events do not forget to call super.
    public override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        if !disablePressAnimations {
            for press in presses {
                if case .Select = press.type {
                    UIView.animateWithDuration(0.12, animations: {
                        self.transform = CGAffineTransformMakeScale(0.95, 0.95)
                    })
                }
            }
        }

        super.pressesBegan(presses, withEvent: event)
    }

    public override func pressesCancelled(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        if !disablePressAnimations {
            for press in presses {
                if case .Select = press.type {
                    UIView.animateWithDuration(0.12, animations: {
                        if self.focused {
                            self.setupFocusedState()
                        } else {
                            self.setupUnfocusedState()
                        }
                    })
                }
            }
        }

        super.pressesCancelled(presses, withEvent: event)
    }

    public override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        if !disablePressAnimations {
            for press in presses {
                if case .Select = press.type {
                    UIView.animateWithDuration(0.12, animations: {
                        if self.focused {
                            self.setupFocusedState()
                        } else {
                            self.setupUnfocusedState()
                        }
                    })
                }
            }
        }

        super.pressesEnded(presses, withEvent: event)
    }

    public override func pressesChanged(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        super.pressesChanged(presses, withEvent: event)
    }

    // MARK: UIFocusEnvironment

    public override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)

        if self == context.nextFocusedView {
            // Add parallax effect to focused cell
            becomeFocusedInContext(context, withAnimationCoordinator: coordinator)
        } else if self == context.previouslyFocusedView {
            // Remove parallax effect
            resignFocusInContext(context, withAnimationCoordinator: coordinator)
        }
    }

    // MARK: ParallaxableView

    public func becomeFocusedInContext(context: UIFocusUpdateContext, withAnimationCoordinator: UIFocusAnimationCoordinator) {
        beforeBecomeFocusedAnimation()

        withAnimationCoordinator.addCoordinatedAnimations({
            self.addParallaxMotionEffects(withOptions: self.parallaxEffectOptions)
            self.setupFocusedState()
            }, completion: nil)
    }

    public func resignFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator: UIFocusAnimationCoordinator) {
        beforeResignFocusAnimation()

        withAnimationCoordinator.addCoordinatedAnimations({
            self.removeParallaxMotionEffects(glowContainerView: self.parallaxEffectOptions.glowContainerView)
            self.setupUnfocusedState()
            }, completion: nil)
    }

    // MARK: Public

    public func setupUnfocusedState() {
        transform = CGAffineTransformIdentity

        layer.shadowOffset = CGSize(width: 0, height: bounds.height*0.015)
        layer.shadowRadius = 5
    }

    public func setupFocusedState() {
        transform = CGAffineTransformMakeScale(1.15, 1.15)

        layer.shadowOffset = CGSize(width: 0, height: bounds.height*0.12)
        layer.shadowRadius = 15
    }

    public func beforeBecomeFocusedAnimation() {
        layer.zPosition = 100
    }

    public func beforeResignFocusAnimation() {
        layer.zPosition = 0
    }

}
