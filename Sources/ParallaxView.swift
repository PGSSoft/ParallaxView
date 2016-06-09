//
//  ParallaxCollectionViewCell.swift
//
//  Created by Łukasz Śliwiński on 20/04/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import UIKit

public class ParallaxView: UIView, ParallaxableView {

    // MARK: Properties

    lazy public var glowEffect: UIImageView = {
        return ParallaxView.loadGlowImage()
    }()

    /// A View that will be a container for the glow effect. Default it will be automatically added as subview in the parallaxContainerView.
    public weak var glowEffectContainerView: UIView? {
        willSet(newValue) {
            glowEffectContainerView?.removeFromSuperview()
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
        glowEffect.alpha = 1.0

        if glowEffectContainerView == nil {
            let view = UIView(frame: bounds)
            addSubview(view)
            glowEffectContainerView = view
        }
    }

    // MARK: UIView

    public override func canBecomeFocused() -> Bool {
        return true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        guard let glowEffectContainerView = glowEffectContainerView else { return }


        if glowEffectContainerView != self, let glowSuperView = glowEffectContainerView.superview {
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
        for press in presses {
            if case .Select = press.type {
                UIView.animateWithDuration(0.1, animations: {
                    self.transform = CGAffineTransformMakeScale(0.95, 0.95)
                })
            }
        }

        super.pressesBegan(presses, withEvent: event)
    }

    public override func pressesCancelled(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for press in presses {
            if case .Select = press.type {
                UIView.animateWithDuration(0.1, animations: {
                    if self.focused {
                        self.setupFocusedState()
                    } else {
                        self.setupUnfocusedState()
                    }
                })
            }
        }

        super.pressesCancelled(presses, withEvent: event)
    }

    public override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for press in presses {
            if case .Select = press.type {
                UIView.animateWithDuration(0.2, animations: {
                    if self.focused {
                        self.transform = CGAffineTransformIdentity
                        self.setupFocusedState()
                    } else {
                        self.transform = CGAffineTransformIdentity
                        self.setupUnfocusedState()
                    }
                })
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
            resignFocusedInContext(context, withAnimationCoordinator: coordinator)
        }
    }
    
    // MARK: ParallaxableView
    
    public func becomeFocusedInContext(context: UIFocusUpdateContext, withAnimationCoordinator: UIFocusAnimationCoordinator) {
        beforeBecomeFocusedAnimation()
        
        withAnimationCoordinator.addCoordinatedAnimations({
            self.addParallaxMotionEffects()
            self.setupFocusedState()
            }, completion: nil)
    }
    
    public func resignFocusedInContext(context: UIFocusUpdateContext, withAnimationCoordinator: UIFocusAnimationCoordinator) {
        beforeResignFocusAnimation()
        
        withAnimationCoordinator.addCoordinatedAnimations({
            self.removeParallaxMotionEffects()
            self.setupUnfocusedState()
            }, completion: nil)
    }

}
