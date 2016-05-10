//
//  ParallaxCollectionViewCell.swift
//  Jenkins
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

    weak public var parallaxContainerView: UIView! {
        return self
    }

    public lazy var glowEffectContainerView: UIView? = {
        self.contentView.layer.cornerRadius = self.layer.cornerRadius
        self.contentView.clipsToBounds = true
        self.contentView.addSubview(self.glowEffect)
        self.contentView.opaque = true
        self.contentView.layer.shouldRasterize = true
        return self.contentView
    }()

    public var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            glowEffectContainerView?.layer.cornerRadius = cornerRadius
        }
    }

    public var subviewsParallaxType: SubviewsParallaxType = .None

    public var shadowPanDeviation = 15.0

    public var parallaxEffect = ParallaxMotionEffect()


    // MARK: Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
        setupUnfocusedState()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        commonInit()
        setupUnfocusedState()
    }

    public override func canBecomeFocused() -> Bool {
        return true
    }

    func commonInit() {
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.35
        layer.shouldRasterize = true
    }

    // MARK: UIView

    public override func layoutSubviews() {
        super.layoutSubviews()

        guard let glowEffectSuperViewBounds = glowEffectContainerView?.superview?.bounds else { return }

        let maxSize = max(glowEffectSuperViewBounds.width, glowEffectSuperViewBounds.height)
        // Make glow a litte bit bigger than cell
        glowEffect.frame = CGRect(x: 0, y: 0, width: maxSize*1.7, height: maxSize*1.7)
        // Position in the middle and under the top edge of the cell
        glowEffect.center = CGPoint(x: glowEffectSuperViewBounds.width/2, y: -glowEffect.frame.height*0.95)
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

    // MARK: Public

    public func setupUnfocusedState() {
        transform = CGAffineTransformIdentity

        layer.shadowOffset = CGSize(width: 0, height: bounds.height*0.015)
        layer.shadowRadius = 5
    }

    public func setupFocusedState() {
        transform = CGAffineTransformScale(transform, 1.15, 1.15)

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
