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
            // Avoid cliping to fully show the shadow
            anyLabel.clipsToBounds = false
        }
    }

    var myContext = 0

    var customGlowContainer: UIView!
    @IBOutlet weak var anyButton: UIButton! {
        didSet {
            // Define custom glow for the parallax effect
            customGlowContainer = UIView(frame: anyButton.bounds)
            customGlowContainer.clipsToBounds = true
            customGlowContainer.backgroundColor = UIColor.clearColor()
            anyButton.subviews.first?.subviews.last?.addSubview(customGlowContainer)

            // Add gray background color to make glow effect be more visible
            anyButton.setBackgroundImage(getImageWithColor(UIColor.lightGrayColor(), size: anyButton.bounds.size), forState: .Normal)
        }
    }

    // MARK: UIViewController

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        customGlowContainer.frame = anyButton.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            // Add parallax effect only to controls inside this view controller
            if let nextFocusedView = context.nextFocusedView where nextFocusedView.isDescendantOfView(self.view) {
                switch context.nextFocusedView {
                case is UIButton:
                    // Custom parallax effect for the button
                    var buttonParallaxEffectOptions = ParallaxEffectOptions(glowContainerView: self.customGlowContainer)
                    self.anyButton.addParallaxMotionEffects(with: &buttonParallaxEffectOptions)
                case is UIFocusableLabel:
                    // Custom parallax effect for the label
                    var labelParallaxEffectOptions = ParallaxEffectOptions()
                    labelParallaxEffectOptions.glowAlpha = 0.0
                    labelParallaxEffectOptions.shadowPanDeviation = 10
                    self.anyLabel.addParallaxMotionEffects(with: &labelParallaxEffectOptions)
                default:
                    // For the anyView use default options
                    context.nextFocusedView?.addParallaxMotionEffects()
                }
            }

            // Remove parallax effect for the view that lost focus
            switch context.previouslyFocusedView {
            case is UIButton:
                // Because anyButton uses custom glow container we have to pass it to remove parallax effect correctly
                self.anyButton.removeParallaxMotionEffects(glowContainer: self.customGlowContainer)
            default:
                context.previouslyFocusedView?.removeParallaxMotionEffects()
            }

            }, completion: nil)
    }

    // MARK: Convenience

    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}

// UIView is not focusable by default, we need to change it
class UIFocusableView: UIView {

    override func canBecomeFocused() -> Bool {
        return true
    }

}

// UILabel is not focusable by default, we need to change it
class UIFocusableLabel: UILabel {

    override func canBecomeFocused() -> Bool {
        return true
    }

}
