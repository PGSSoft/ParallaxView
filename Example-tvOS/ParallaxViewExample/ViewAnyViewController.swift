//
//  ViewAnyViewController.swift
//  ParallaxViewExample
//
//  Created by Łukasz Śliwiński on 16/06/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import UIKit
import ParallaxView

class ViewAnyViewController: UIViewController {

    // MARK: IBOutlets

    @IBOutlet weak var anyView: UIFocusableView!
    @IBOutlet weak var anyLabel: UIFocusableLabel! {
        didSet {
            // Without setting userInteractionEnabled, label can't be focusable
            anyLabel.userInteractionEnabled = true
            anyLabel.layer.shadowColor = UIColor.blackColor().CGColor
            anyLabel.layer.shadowOpacity = 0.5
            anyLabel.layer.shadowOffset = CGSize(width: 0, height: 5)
            // Avoid cliping to show fully shadow
            anyLabel.clipsToBounds = false
        }
    }

    var customGlowContainer: UIView!
    @IBOutlet weak var anyButton: UIButton! {
        didSet {
            customGlowContainer = UIView(frame: self.anyButton.bounds)
            customGlowContainer.clipsToBounds = true
            customGlowContainer.backgroundColor = UIColor.clearColor()
            anyButton.addSubview(customGlowContainer)
        }
    }

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            // Add parallax effect only to controls inside this view controller
            if let nextFocusedView = context.nextFocusedView where nextFocusedView.isDescendantOfView(self.view) {
                switch context.nextFocusedView {
                case is UIButton:
                    let buttonParallaxEffectOptions = ParallaxEffectOptions(glowContainerView: self.customGlowContainer)
                    self.anyButton.addParallaxMotionEffects(withOptions: buttonParallaxEffectOptions)
                case is UIFocusableLabel:
                    let labelParallaxEffectOptions = ParallaxEffectOptions()
                    labelParallaxEffectOptions.glowAlpha = 0.0
                    labelParallaxEffectOptions.shadowPanDeviation = 10
                    self.anyLabel.addParallaxMotionEffects(withOptions: labelParallaxEffectOptions)
                default:
                    context.nextFocusedView?.addParallaxMotionEffects()
                }
            }

            switch context.previouslyFocusedView {
            case is UIButton:
                self.anyButton.removeParallaxMotionEffects(glowContainerView: self.customGlowContainer)
            default:
                context.previouslyFocusedView?.removeParallaxMotionEffects()
            }

            }, completion: nil)

    }

}


class UIFocusableView: UIView {

    override func canBecomeFocused() -> Bool {
        return true
    }

}

class UIFocusableLabel: UILabel {

    override func canBecomeFocused() -> Bool {
        return true
    }

}
