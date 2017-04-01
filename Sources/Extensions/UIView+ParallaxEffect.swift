//
//  UIView+ParallaxEffect.swift
//  ParallaxView
//
//  Created by Łukasz Śliwiński on 15/06/16.
//
//

import UIKit

public protocol AnyParallaxableView {
    func addParallaxMotionEffects()
    func addParallaxMotionEffects(with options: inout ParallaxEffectOptions)
    func removeParallaxMotionEffects(with options: ParallaxEffectOptions?)
}

extension UIView: AnyParallaxableView {
    
    public func addParallaxMotionEffects() {
        var options = ParallaxEffectOptions()
        addParallaxMotionEffects(with: &options)
    }

    public func addParallaxMotionEffects(with options: inout ParallaxEffectOptions) {
        // If glow have to be visible and glowContainerView is not given then set it to self
        if options.glowContainerView == nil && options.glowAlpha > 0.0 {
            options.glowContainerView = self
        }
        
        if let glowContainerView = options.glowContainerView {
            // Need to clip to bounds because of the glow effect
            glowContainerView.clipsToBounds = true
            
            // Configure glow image
            let glowImageView = options.glowImageView
            glowImageView.alpha = CGFloat(options.glowAlpha)
            glowContainerView.addSubview(glowImageView)
            
            // Configure frame of the glow effect without animation
            UIView.performWithoutAnimation {
                let maxSize = max(glowContainerView.frame.width, glowContainerView.frame.height)*1.7
                // Make glow a litte bit bigger than the superview
                glowImageView.frame = CGRect(x: 0, y: 0, width: maxSize, height: maxSize)
                // Position in the middle and under the top edge of the superview
                glowImageView.center = CGPoint(x: glowContainerView.frame.width/2, y: -glowImageView.frame.height)
            }
            
            // Configure pan motion effect for the glow
            let verticalGlowEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
            verticalGlowEffect.minimumRelativeValue = -glowImageView.frame.height * CGFloat(options.minVerticalPanGlowMultipler)
            verticalGlowEffect.maximumRelativeValue = glowImageView.frame.height * CGFloat(options.maxVerticalPanGlowMultipler)
            
            let horizontalGlowEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
            horizontalGlowEffect.minimumRelativeValue = -bounds.width+glowImageView.frame.width/4
            horizontalGlowEffect.maximumRelativeValue = bounds.width-glowImageView.frame.width/4
            
            let glowMotionGroup = UIMotionEffectGroup()
            glowMotionGroup.motionEffects = [horizontalGlowEffect, verticalGlowEffect]
            
            glowImageView.addMotionEffect(glowMotionGroup)
        }
        
        let motionGroup = UIMotionEffectGroup()
        motionGroup.motionEffects = []
        
        // Add parallax effect
        motionGroup.motionEffects?.append(options.parallaxMotionEffect)
        
        // Configure shadow pan motion effect
        if options.shadowPanDeviation != 0 {
            let veriticalShadowEffect = UIInterpolatingMotionEffect(keyPath: "layer.shadowOffset.height", type: .tiltAlongVerticalAxis)
            veriticalShadowEffect.minimumRelativeValue = -options.shadowPanDeviation
            veriticalShadowEffect.maximumRelativeValue = options.shadowPanDeviation/2
            
            let horizontalShadowEffect = UIInterpolatingMotionEffect(keyPath: "layer.shadowOffset.width", type: .tiltAlongHorizontalAxis)
            horizontalShadowEffect.minimumRelativeValue = -options.shadowPanDeviation
            horizontalShadowEffect.maximumRelativeValue = options.shadowPanDeviation
            
            motionGroup.motionEffects?.append(contentsOf: [veriticalShadowEffect, horizontalShadowEffect])
        }
        
        addMotionEffect(motionGroup)
        
        // Configure pan motion effect for the subviews
        if case .none = options.subviewsParallaxMode {
        } else {
            (options.parallaxSubviewsContainer ?? self).subviews
                .filter { $0 !== options.glowContainerView }
                .enumerated()
                .forEach { (index: Int, subview: UIView) in
                    let relativePanValue: Double
                    
                    switch options.subviewsParallaxMode {
                    case .basedOnHierarchyInParallaxView(let maxOffset, let multipler):
                        relativePanValue = maxOffset / (Double(index+1)) * (multipler ?? 1.0)
                    case .basedOnTag:
                        relativePanValue = Double(subview.tag)
                    default:
                        relativePanValue = 0.0
                    }
                    
                    let verticalSubviewEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
                    verticalSubviewEffect.minimumRelativeValue = -relativePanValue
                    verticalSubviewEffect.maximumRelativeValue = relativePanValue
                    
                    let horizontalSubviewEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
                    horizontalSubviewEffect.minimumRelativeValue = -relativePanValue
                    horizontalSubviewEffect.maximumRelativeValue = relativePanValue
                    
                    let group = UIMotionEffectGroup()
                    group.motionEffects = [verticalSubviewEffect, horizontalSubviewEffect]
                    subview.addMotionEffect(group)
            }
        }
    }
    
    public func removeParallaxMotionEffects(with options: ParallaxEffectOptions? = nil) {
        motionEffects.removeAll()
        (options?.parallaxSubviewsContainer ?? self).subviews
            .filter { $0 !== options?.glowContainerView }
            .forEach { (subview: UIView) in
                subview.motionEffects.removeAll()
        }

        options?.glowImageView.motionEffects.removeAll()
        options?.glowImageView.removeFromSuperview()
    }
    
}
