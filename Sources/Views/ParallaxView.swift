//
//  ParallaxCollectionViewCell.swift
//
//  Created by Łukasz Śliwiński on 20/04/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import UIKit

/// An object that provides default implementation of the parallax effect for the `UIView`.
/// If you will override `init` method it is important to provide default setup for the unfocused state of the view
/// e.g. `parallaxViewActions.setupUnfocusedState?(self)`
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

    /// Override this method in your `ParallaxView` subclass if you would like to provide custom
    /// setup for the `parallaxEffectOptions` and/or `parallaxViewActions`
    open func setupParallax() {}

    internal func commonInit() {
        if parallaxEffectOptions.glowContainerView == nil {
            let view = UIView(frame: bounds)
            addSubview(view)
            parallaxEffectOptions.glowContainerView = view
        }

        setupParallax()
    }

    // MARK: UIView

    open override var canBecomeFocused : Bool {
        return true
    }

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
