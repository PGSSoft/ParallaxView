//
//  ParallaxEffectOptions.swift
//  ParallaxView
//
//  Created by Łukasz Śliwiński on 15/06/16.
//
//

import UIKit

/// A type that allows to customize parallax effet
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
    public weak var glowContainerView: UIView? {
        didSet { oldValue?.removeFromSuperview() }
    }
    /// Minimum vertical value at the most top position can be adjusted by this multipler
    public var minVerticalPanGlowMultipler: Double = 0.2
    /// Maximum vertical value at the most bottom position can be adjusted by this multipler
    public var maxVerticalPanGlowMultipler: Double = 1.55
    /// Alpha of the glow image view
    public var glowAlpha: Double = 1.0 {
        didSet { self.glowImageView.alpha = CGFloat(glowAlpha) }
    }
    /// Glow effect image view
    public var glowImageView: UIImageView = ParallaxEffectOptions.defaultGlowImageView()
    /// Glow position
    public var glowPosition: GlowPosition = .top

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

extension ParallaxEffectOptions {

    public struct GlowPosition {
        let layout: (UIView, UIImageView) -> Void

        public static let top: GlowPosition = .init(layout: { (glowEffectContainerView, glowImageView) in
            if let glowSuperView = glowEffectContainerView.superview {
                glowEffectContainerView.frame = glowSuperView.bounds
            }

            // Make glow a litte bit bigger than the superview
            let maxSize = max(glowEffectContainerView.frame.width, glowEffectContainerView.frame.height)*1.7
            glowImageView.frame = CGRect(x: 0, y: 0, width: maxSize, height: maxSize)

            // Position in the middle and under the top edge of the superview
            glowImageView.center = CGPoint(x: glowEffectContainerView.frame.width/2, y: -glowImageView.frame.height)
        })

        public static let center: GlowPosition = .init(layout: { (glowEffectContainerView, glowImageView) in
            GlowPosition.top.layout(glowEffectContainerView, glowImageView)
            glowImageView.center = CGPoint(x: glowEffectContainerView.frame.width/2, y: -glowImageView.frame.height/2)
        })
    }
}

internal let glowImageAccessibilityIdentifier = "com.pgs-soft.parallaxview.gloweffect"

extension ParallaxEffectOptions {
    
    static func defaultGlowImageView() -> UIImageView {
        #if SWIFT_PACKAGE
        let bundle = Bundle.module
        #else
        let bundle = Bundle(for: ParallaxView.self)
        #endif

        if let glowImage = UIImage(named: "gloweffect", in: bundle, compatibleWith: nil) {
            glowImage.accessibilityIdentifier = glowImageAccessibilityIdentifier
            let imageView = UIImageView(image: glowImage)
            imageView.contentMode = .scaleAspectFit
            
            return UIImageView(image: glowImage)
        } else {
            fatalError("Can't initialize gloweffect image")
        }
    }
    
}
