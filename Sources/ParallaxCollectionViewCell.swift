//
//  ParallaxCollectionViewCell.swift
//  Jenkins
//
//  Created by Łukasz Śliwiński on 20/04/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import UIKit

public class ParallaxCollectionReusableView: ParallaxView {

}

public class ParallaxCollectionViewCell: ParallaxCollectionReusableView {

    public override func setupUnfocusedState() {
        transform = CGAffineTransformIdentity

        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: bounds.height*0.015)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
    }

    public override func setupFocusedState() {
        transform = CGAffineTransformScale(transform, 1.15, 1.15)

        layer.shadowColor = self.backgroundColor?.CGColor
        layer.shadowOffset = CGSize(width: 0, height: bounds.height*0.12)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 25
    }

    public override func beforeBecomeFocusedAnimation() {
        layer.zPosition = 100
    }

    public override func beforeResignFocusAnimation() {
        layer.zPosition = 0
    }

}
