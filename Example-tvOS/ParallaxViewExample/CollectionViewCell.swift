//
//  CollectionViewCell.swift
//  ParallaxViewExample
//
//  Created by Łukasz Śliwiński on 09/05/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import UIKit
import ParallaxView

class CollectionViewCell: ParallaxCollectionViewCell {
    
    private var widthToHeightRatio = CGFloat(0)

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // Here u can configure custom properties for parallax effect
        cornerRadius = 8
        glowEffectAlpha = 1.0
        
        shadowPanDeviation = 10
        parallaxEffect.viewingAngleX = CGFloat(M_PI_4/30)
        parallaxEffect.viewingAngleY = CGFloat(M_PI_4/30)
        parallaxEffect.panValue = 5
        
        shadowPanDeviation = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        widthToHeightRatio = round(((bounds.width * 0.08 + bounds.height)/bounds.height)*100)/100
    }

    // You can customzie view depending on control state e.g:

    override func setupUnfocusedState() {
        transform = CGAffineTransformIdentity

        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 5
    }

    override func setupFocusedState() {
        transform = CGAffineTransformMakeScale(1.08, widthToHeightRatio)

        layer.shadowOffset = CGSize(width: 0, height: 20)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 15
    }

    override func beforeBecomeFocusedAnimation() {
        // Here you can make same adjustmens before animation to focus state will be started
        super.beforeBecomeFocusedAnimation()

        // It is useful to set bigger zPosition than unfocused cell. Especially when they overlap during the transition.
        // Calling super.beforeBecomeFocusedAnimation will do that for you
//        layer.zPosition = 100
    }

    override func beforeResignFocusAnimation() {
        super.beforeResignFocusAnimation()
//        layer.zPosition = 0
    }


}
