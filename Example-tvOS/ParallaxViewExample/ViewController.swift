//
//  ViewController.swift
//  ParallaxViewExample
//
//  Created by Łukasz Śliwiński on 09/05/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import UIKit
import ParallaxView

class ViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var parallaxView: ParallaxView! {
        didSet {
            // Configure shadow
            parallaxView.layer.shadowRadius = 15
            parallaxView.layer.shadowColor = UIColor.blackColor().CGColor
            parallaxView.layer.shadowOffset = CGSize(width: 0, height: 20)
            parallaxView.layer.shadowOpacity = 0.3

            parallaxView.cornerRadius = 10

            // Configure parallax view
            let glowEffectView = UIView(frame: parallaxView.bounds)
            parallaxView.insertSubview(glowEffectView, aboveSubview: label)
            parallaxView.glowEffectAlpha = 0.5
            parallaxView.glowEffectContainerView = glowEffectView
        }
    }

    @IBOutlet weak var label: UILabel! {
        didSet {
            label.layer.shadowOffset = CGSize(width: 0, height: 2)
            label.layer.shadowColor = UIColor.blackColor().CGColor
            label.layer.shadowRadius = 5
            label.layer.shadowOpacity = 0.4
            label.layer.shouldRasterize = true
        }
    }

    @IBOutlet weak var biggerLabel: UILabel!

    @IBOutlet weak var theBiggestLabel: UILabel!

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        //parallaxView.subviewsParallaxType = .BasedOnHierarchyInParallaxView(maxParallaxOffset: 20)

        // Uncomment lines below to test out subviews parallax effect based on tag
        parallaxView.subviewsParallaxType = .BasedOnTag
        label.tag = 10
        biggerLabel.tag = 15
        theBiggestLabel.tag = 25
    }

    // MARK: UIFocusEnvironment

    override var preferredFocusedView: UIView? {
        return parallaxView
    }

}
