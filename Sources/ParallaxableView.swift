//
//  ParallaxableView.swift
//
//  Created by Łukasz Śliwiński on 10/05/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import UIKit

public protocol ParallaxableView: class {

    var parallaxEffect: ParallaxMotionEffect { get set }

    var subviewsParallaxType: SubviewsParallaxType { get set }

    var shadowPanDeviation: Double { get set }

    var glowEffectAlpha: CGFloat { get set }

    var cornerRadius: CGFloat { get set }

    weak var glowEffectContainerView: UIView? { get }

    var glowEffect: UIImageView { get }

    func setupUnfocusedState()

    func setupFocusedState()

    func beforeBecomeFocusedAnimation()

    func beforeResignFocusAnimation()

    func becomeFocusedUsingAnimationCoordinator(coordinator: UIFocusAnimationCoordinator)

    func resignFocusUsingAnimationCoordinator(coordinator: UIFocusAnimationCoordinator)

}
