//
//  ParallaxEffectOptions.swift
//  ParallaxView
//
//  Created by Łukasz Śliwiński on 15/06/16.
//
//

import UIKit

public class ParallaxEffectOptions {

    /// Property allow to customize parallax effect (pan, angles, etc.)
    ///
    /// - seealso:
    ///  [ParallaxEffect](ParallaxEffect)
    public var parallaxMotionEffect = ParallaxMotionEffect()

    /// Maximum deviation of the shadow relative to the center
    public var shadowPanDeviation: Double = 0.0
    /// Specify parallax effect of subiviews of the `parallaxEffectView`
    public var subviewsParallaxMode = SubviewsParallaxMode.None
    /// A View that will be a container for the glow effect
    public weak var glowContainerView: UIView?
    /// Minimum vertical value at the most top position can be adjusted by this multipler
    public var minVerticalPanGlowMultipler: Double = 0.2
    /// Maximum vertical value at the most bottom position can be adjusted by this multipler
    public var maxVerticalPanGlowMultipler: Double = 1.55
    public var glowAlpha: Double = 1.0

    public init(glowContainerView: UIView? = nil) {
        self.glowContainerView = glowContainerView
    }

}
