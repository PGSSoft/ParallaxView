//
//  ParallaxableView.swift
//
//  Created by Łukasz Śliwiński on 10/05/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import UIKit

public protocol ParallaxableView: class {

    var parallaxEffectOptions: ParallaxEffectOptions { get set }

    var cornerRadius: CGFloat { get set }

    var disablePressAnimations: Bool { get set }

    func setupUnfocusedState()

    func setupFocusedState()

    func beforeBecomeFocusedAnimation()

    func beforeResignFocusAnimation()

    func becomeFocusedInContext(context: UIFocusUpdateContext, withAnimationCoordinator: UIFocusAnimationCoordinator)

    func resignFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator: UIFocusAnimationCoordinator)

}
