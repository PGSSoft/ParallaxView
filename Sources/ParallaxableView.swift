//
//  ParallaxableView.swift
//  Pods
//
//  Created by Łukasz Śliwiński on 10/05/16.
//
//

import UIKit

public protocol ParallaxableView {

    /**
     Property allow to customize parallax effect (pan, angles, etc.)

     - seealso:
     See field
     [ParallaxEffect.swift](ParallaxEffect.swift)

     */
    var parallaxEffect: ParallaxMotionEffect { get set }
    /// Specify parallax effect of subiviews of the `parallaxEffectView`.
    var subviewsParallaxType: SubviewsParallaxType { get set }
    /// Maximum deviation of the shadow relative to the center
    var shadowPanDeviation: Double { get set }

    var glowEffectAlpha: CGFloat { get set }

    var cornerRadius: CGFloat { get set }
    /// View that will be used to manage parallaxEffect.
    weak var parallaxContainerView: UIView! { get }
    /// View that will be a container for glow effect.
    weak var glowEffectContainerView: UIView? { get }

    var glowEffect: UIImageView { get }

    func setupUnfocusedState()

    func setupFocusedState()

    func beforeBecomeFocusedAnimation()

    func beforeResignFocusAnimation()

    func becomeFocusedUsingAnimationCoordinator(coordinator: UIFocusAnimationCoordinator)

    func resignFocusUsingAnimationCoordinator(coordinator: UIFocusAnimationCoordinator)

}
