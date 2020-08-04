//
//  ParallaxCollectionViewCell.swift
//
//  Created by Łukasz Śliwiński on 20/04/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import UIKit

/// An object that provides default implementation of the parallax effect for the `UICollectionViewCell`.
/// Most of the time you will subclass this class as you would with `UICollectionViewCell` to provide custom content.
/// If you will override `init` method it is important to provide default setup for the unfocused state of the view
/// e.g. `parallaxViewActions.setupUnfocusedState?(self)`
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

    /// Override this method in your `ParallaxCollectionViewCell` subclass if you would like to provide custom
    /// setup for the `parallaxEffectOptions` and/or `parallaxViewActions`
    open func setupParallax() {}

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

        setupParallax()
    }

    // MARK: UIView

    open override func layoutSubviews() {
        super.layoutSubviews()

        guard let glowEffectContainerView = parallaxEffectOptions.glowContainerView,
              let glowImageView = getGlowImageView()
        else { return }

        parallaxEffectOptions.glowPosition.layout(glowEffectContainerView, glowImageView)
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
