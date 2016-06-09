//
//  ParallaxCollectionViewCell.swift
//
//  Created by Łukasz Śliwiński on 20/04/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import UIKit

public class ParallaxCollectionViewCell: UICollectionViewCell, ParallaxableView {

    // MARK: Properties

    lazy public var glowEffect: UIImageView = {
        return ParallaxView.loadGlowImage()
    }()

    /// A View that will be a container for the glow effect. Default it will be contentView.
    public weak var glowEffectContainerView: UIView? {
        willSet(newValue) {
            if let glowEffectContainerView = glowEffectContainerView where glowEffectContainerView != self && glowEffectContainerView != contentView {
                glowEffectContainerView.removeFromSuperview()
            }
        }
        didSet {
            glowEffectContainerView?.layer.cornerRadius = cornerRadius
            glowEffectContainerView?.clipsToBounds = true
            glowEffectContainerView?.opaque = true
            glowEffectContainerView?.layer.shouldRasterize = true
            glowEffectContainerView?.addSubview(glowEffect)
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    /// Specify parallax effect of subiviews of the `parallaxEffectView`
    public var subviewsParallaxType: SubviewsParallaxType = .None

    /// Maximum deviation of the shadow relative to the center
    public var shadowPanDeviation = 15.0


    /// Property allow to customize parallax effect (pan, angles, etc.)
    ///
    /// - seealso:
    ///  [ParallaxEffect](ParallaxEffect)
    public var parallaxEffect = ParallaxMotionEffect()

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

        if glowEffectContainerView == nil {
            glowEffectContainerView = contentView
        }
    }

    // MARK: UIView

    public override func canBecomeFocused() -> Bool {
        return true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        guard let glowEffectContainerView = glowEffectContainerView else { return }

        if glowEffectContainerView != self && glowEffectContainerView != contentView, let glowSuperView = glowEffectContainerView.superview {
            glowEffectContainerView.frame = glowSuperView.bounds
        }

        let maxSize = max(glowEffectContainerView.frame.width, glowEffectContainerView.frame.height)*1.7
        // Make glow a litte bit bigger than the superview
        glowEffect.frame = CGRect(x: 0, y: 0, width: maxSize, height: maxSize)
        // Position in the middle and under the top edge of the superview
        glowEffect.center = CGPoint(x: glowEffectContainerView.frame.width/2, y: -glowEffectContainerView.frame.height*0.9)
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
            becomeFocusedUsingAnimationCoordinator(coordinator)
        } else if self == context.previouslyFocusedView {
            // Remove parallax effect
            resignFocusUsingAnimationCoordinator(coordinator)
        }
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
