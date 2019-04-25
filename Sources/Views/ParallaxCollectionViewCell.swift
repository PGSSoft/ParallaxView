//
//  ParallaxCollectionViewCell.swift
//
//  Created by Łukasz Śliwiński on 20/04/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import UIKit

open class ParallaxCollectionViewCell: UICollectionViewCell, ParallaxableView {

    // MARK: Properties

    open var parallaxEffectOptions = ParallaxEffectOptions()
    open var parallaxViewActions = ParallaxViewActions<ParallaxCollectionViewCell>()

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
        layer.shadowOpacity = 0.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.35
        layer.shouldRasterize = true

        if parallaxEffectOptions.glowContainerView == nil {
            parallaxEffectOptions.glowContainerView = contentView
        }

        if parallaxEffectOptions.parallaxSubviewsContainer == nil {
            parallaxEffectOptions.parallaxSubviewsContainer = contentView
        }

        parallaxViewActions.setupUnfocusedState = { [weak self] (view) in
            guard let _self = self else { return }
            view.transform = CGAffineTransform.identity

            view.layer.shadowOffset = CGSize(width: 0, height: _self.bounds.height*0.015)
            view.layer.shadowRadius = 5
        }

        parallaxViewActions.setupFocusedState = { [weak self] (view) in
            guard let _self = self else { return }
            view.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)

            view.layer.shadowOffset = CGSize(width: 0, height: _self.bounds.height*0.12)
            view.layer.shadowRadius = 15
        }

        parallaxViewActions.beforeResignFocusAnimation = { $0.layer.zPosition = 0 }
        parallaxViewActions.beforeBecomeFocusedAnimation = { $0.layer.zPosition = 100 }
    }

    // MARK: UIView

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

        if self == context.nextFocusedView {
            // Add parallax effect to focused cell
            parallaxViewActions.becomeFocused?(self, context, coordinator)
        } else if self == context.previouslyFocusedView {
            // Remove parallax effect
            parallaxViewActions.resignFocus?(self, context, coordinator)
        }
    }

}
