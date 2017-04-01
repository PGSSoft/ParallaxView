//
//  ParallaxEffectOptions.swift
//  ParallaxView
//
//  Created by Łukasz Śliwiński on 15/06/16.
//
//

import UIKit

public struct ParallaxEffectOptions {
    
    /// Property allow to customize parallax effect (pan, angles, etc.)
    ///
    /// - seealso:
    ///  [ParallaxMotionEffect](ParallaxMotionEffect)
    public var parallaxMotionEffect = ParallaxMotionEffect()
    /// Maximum deviation of the shadow relative to the center
    public var shadowPanDeviation: Double = 0.0
    /// Specify parallax effect of subiviews of the `parallaxEffectView`
    public var subviewsParallaxMode = SubviewsParallaxMode.none
    /// Custom container view that will be usead to apply subviews parallax effect
    public var parallaxSubviewsContainer: UIView?
    /// A view that will be a container for the glow effect
    public weak var glowContainerView: UIView?
    /// Minimum vertical value at the most top position can be adjusted by this multipler
    public var minVerticalPanGlowMultipler: Double = 0.2
    /// Maximum vertical value at the most bottom position can be adjusted by this multipler
    public var maxVerticalPanGlowMultipler: Double = 1.55
    /// Alpha of the glow image view
    public var glowAlpha: Double = 1.0
    /// Glow effect image view
    public var glowImageView: UIImageView = ParallaxEffectOptions.defaultGlowImageView()

    /// Constructor
    ///
    /// - Parameters:
    ///   - parallaxSubviewsContainer: Custom container view that will be usead to apply subviews parallax effect. By default it will be parallaxable view
    ///   - glowContainerView: Custom container view for the glow effect, if nil then it will be automatically configured
    public init(parallaxSubviewsContainer: UIView? = nil, glowContainerView: UIView? = nil) {
        self.parallaxSubviewsContainer = parallaxSubviewsContainer
        self.glowContainerView = glowContainerView
    }
    
}

internal let glowImageAccessibilityIdentifier = "com.pgs-soft.parallaxview.gloweffect"

extension ParallaxEffectOptions {
    
    static func defaultGlowImageView() -> UIImageView {
        if case let bundle = Bundle(for: ParallaxView.self), let glowImage = UIImage(named: "gloweffect", in: bundle, compatibleWith: nil) {
            glowImage.accessibilityIdentifier = glowImageAccessibilityIdentifier
            let imageView = UIImageView(image: glowImage)
            imageView.contentMode = .scaleAspectFit
            
            return UIImageView(image: glowImage)
        } else {
            fatalError("Can't initialize gloweffect image")
        }
    }
    
}
