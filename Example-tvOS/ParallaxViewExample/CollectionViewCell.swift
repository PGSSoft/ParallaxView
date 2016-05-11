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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // Here u can configure custom properties for parallax effect
        cornerRadius = 8
        glowEffectAlpha = 0.4
    }

    // You can customzie view depending on control state e.g:

    override func setupUnfocusedState() {
        transform = CGAffineTransformIdentity

        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 5
    }

    override func setupFocusedState() {
        transform = CGAffineTransformScale(transform, 1.15, 1.15)

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
