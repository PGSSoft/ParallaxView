//
//  ParallaxCollectionViewCell.swift
//
//  Created by Łukasz Śliwiński on 20/04/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import UIKit

public class ParallaxView: UIView, ParallaxableView {

    // MARK: Properties

    public var parallaxEffectOptions = ParallaxEffectOptions()
    public var parallaxViewActions = ParallaxViewActions<ParallaxView>()

    // MARK: Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
        parallaxViewActions.setupUnfocusedState?(self)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
        parallaxViewActions.setupUnfocusedState?(self)
    }

    internal func commonInit() {
        if parallaxEffectOptions.glowContainerView == nil {
            let view = UIView(frame: bounds)
            addSubview(view)
            parallaxEffectOptions.glowContainerView = view
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
        parallaxViewActions.animatePressIn?(self, presses: presses, event: event)

        super.pressesBegan(presses, withEvent: event)
    }

    public override func pressesCancelled(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        parallaxViewActions.animatePressOut?(self, presses: presses, event: event)

        super.pressesCancelled(presses, withEvent: event)
    }

    public override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        parallaxViewActions.animatePressOut?(self, presses: presses, event: event)

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
            parallaxViewActions.becomeFocused?(self, context: context, animationCoordinator: coordinator)
        } else if self == context.previouslyFocusedView {
            // Remove parallax effect
            parallaxViewActions.resignFocus?(self, context: context, animationCoordinator: coordinator)
        }
    }

}
