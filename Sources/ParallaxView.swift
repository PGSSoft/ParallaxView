//
//  ParallaxCollectionViewCell.swift
//  Jenkins
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

    /// View that will be a container for glow effect. If nil then glow effect will be not visible.
    public weak var glowEffectContainerView: UIView? {
        willSet(newValue) {
            glowEffectContainerView?.removeFromSuperview()
        }
        didSet {
            glowEffectContainerView?.layer.cornerRadius = cornerRadius
            glowEffectContainerView?.clipsToBounds = true
            glowEffectContainerView?.addSubview(glowEffect)
            glowEffectContainerView?.opaque = true
            glowEffectContainerView?.layer.shouldRasterize = true
        }
    }

    /// View that will be used to manage parallaxEffect. Default it will be Self.
    public weak var parallaxContainerView: UIView! {
        didSet {
            parallaxContainerView.layer.shouldRasterize = true
        }
    }
    /// Specify parallax effect of subiviews of the `parallaxEffectView`.
    public var subviewsParallaxType: SubviewsParallaxType = .None

    /// Maximum deviation of the shadow relative to the center
    public var shadowPanDeviation = 15.0

    /**
     Property allow to customize parallax effect (pan, angles, etc.)

     - seealso:
     See field
     [ParallaxEffect.swift](ParallaxEffect.swift)

     */
    public var parallaxEffect = ParallaxMotionEffect()

    // MARK: Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
        setupUnfocusedState()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        setupUnfocusedState()
    }

    // MARK: Private

    internal func commonInit() {
        glowEffect.alpha = 1.0

        if parallaxContainerView == nil {
            parallaxContainerView = self
        }
    }

    // MARK: UIView

    public override func canBecomeFocused() -> Bool {
        return true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        guard let glowEffectContainerView = glowEffectContainerView else { return }

        let glowEffectContainerBounds: CGRect?
        if glowEffectContainerView == self {
            glowEffectContainerBounds = bounds
        } else {
            glowEffectContainerBounds = glowEffectContainerView.superview?.bounds
        }

        if let glowEffectContainerBounds = glowEffectContainerBounds {
            let maxSize = max(glowEffectContainerBounds.width, glowEffectContainerBounds.height)
            // Make glow a litte bit bigger than cell
            glowEffect.frame = CGRect(x: 0, y: 0, width: maxSize*1.7, height: maxSize*1.7)
            // Position in the middle and under the top edge of the cell
            glowEffect.center = CGPoint(x: glowEffectContainerBounds.width/2, y: -glowEffect.frame.height*0.95)
        }
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
            print(">> becomeFocusedUsingAnimationCoordinator", self, context.nextFocusedView?.backgroundColor)

            // Add parallax effect to focused cell
            becomeFocusedUsingAnimationCoordinator(coordinator)
        } else {
            print(">> resignFocusUsingAnimationCoordinator", self, context.previouslyFocusedView?.backgroundColor)

            // Remove parallax effect
            resignFocusUsingAnimationCoordinator(coordinator)
        }
    }

}
