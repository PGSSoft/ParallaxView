//
//  ParallaxCollectionViewCell.swift
//
//  Created by Łukasz Śliwiński on 20/04/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import UIKit

open class ParallaxView: UIView, ParallaxableView {

    // MARK: Properties

    open var parallaxEffectOptions = ParallaxEffectOptions()
    open var parallaxViewActions = ParallaxViewActions<ParallaxView>()

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

    open override var canBecomeFocused : Bool {
        return true
    }

    open override func layoutSubviews() {
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
    open override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        parallaxViewActions.animatePressIn?(self, presses, event)

        super.pressesBegan(presses, with: event)
    }

    open override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        parallaxViewActions.animatePressOut?(self, presses, event)

        super.pressesCancelled(presses, with: event)
    }

    open override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        parallaxViewActions.animatePressOut?(self, presses, event)

        super.pressesEnded(presses, with: event)
    }

    open override func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesChanged(presses, with: event)
    }

    // MARK: UIFocusEnvironment

    open override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)

        guard context.nextFocusedView != context.previouslyFocusedView else { return }
        switch self {
        case context.nextFocusedView:
            parallaxViewActions.becomeFocused?(self, context, coordinator)
        case context.previouslyFocusedView:
            parallaxViewActions.resignFocus?(self, context, coordinator)
        default:
            break
        }
    }

}
