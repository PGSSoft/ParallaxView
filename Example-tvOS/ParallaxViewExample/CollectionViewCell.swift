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

    fileprivate var widthToHeightRatio = CGFloat(0)

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // Here you can configure custom properties for parallax effect
        cornerRadius = 8

        parallaxEffectOptions.glowAlpha = 0.4
        parallaxEffectOptions.shadowPanDeviation = 10
        parallaxEffectOptions.parallaxMotionEffect.viewingAngleX = CGFloat(Double.pi/4/30)
        parallaxEffectOptions.parallaxMotionEffect.viewingAngleY = CGFloat(Double.pi/4/30)
        parallaxEffectOptions.parallaxMotionEffect.panValue = CGFloat(5)

        // You can customise parallax view standard behaviours using parallaxViewActions property.
        // Do not forget to use weak self if needed to void retain cycle
        parallaxViewActions.setupUnfocusedState = { (view) -> Void in
            view.transform = CGAffineTransform.identity

            view.layer.shadowOffset = CGSize(width: 0, height: 10)
            view.layer.shadowOpacity = 0.3
            view.layer.shadowRadius = 5
            view.layer.shadowColor = UIColor.black.cgColor
        }

        parallaxViewActions.setupFocusedState = { [weak self] (view) -> Void in
            guard let _self = self else { return }
            view.transform = CGAffineTransform(scaleX: 1.08, y: _self.widthToHeightRatio)

            view.layer.shadowOffset = CGSize(width: 0, height: 20)
            view.layer.shadowOpacity = 0.4
            view.layer.shadowRadius = 15
            view.layer.shadowColor = view.backgroundColor?.cgColor
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        widthToHeightRatio = round(((bounds.width * 0.08 + bounds.height)/bounds.height)*100)/100
    }
    
    override var canBecomeFocused: Bool {
        return true
    }

}
