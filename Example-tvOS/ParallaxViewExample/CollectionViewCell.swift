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

        parallaxEffectOptions.glowAlpha = 0.4
        parallaxEffectOptions.shadowPanDeviation = 10
        parallaxEffectOptions.parallaxMotionEffect.viewingAngleX = CGFloat(M_PI_4/30)
        parallaxEffectOptions.parallaxMotionEffect.viewingAngleY = CGFloat(M_PI_4/30)
        parallaxEffectOptions.parallaxMotionEffect.panValue = CGFloat(5)

        parallaxViewActions.setupUnfocusedState = { (view) -> Void in
            view.transform = CGAffineTransformIdentity

            view.layer.shadowOffset = CGSize(width: 0, height: 10)
            view.layer.shadowOpacity = 0.3
            view.layer.shadowRadius = 5
        }

        parallaxViewActions.setupFocusedState = { [weak self] (view) -> Void in
            guard let _self = self else { return }
            view.transform = CGAffineTransformMakeScale(1.08, _self.widthToHeightRatio)

            view.layer.shadowOffset = CGSize(width: 0, height: 20)
            view.layer.shadowOpacity = 0.4
            view.layer.shadowRadius = 15
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        widthToHeightRatio = round(((bounds.width * 0.08 + bounds.height)/bounds.height)*100)/100
    }

    // You can customzie view depending on control state e.g:
//
//    func beforeBecomeFocusedAnimation() {
//        // Here you can make same adjustmens before animation to focus state will be started
////        super.beforeBecomeFocusedAnimation()
//
//        // It is useful to set bigger zPosition than unfocused cell. Especially when they overlap during the transition.
//        // Calling super.beforeBecomeFocusedAnimation will do that for you
//        layer.zPosition = 100
//    }
//
//    func beforeResignFocusAnimation() {
////        super.beforeResignFocusAnimation()
//        layer.zPosition = 0
//    }

}
