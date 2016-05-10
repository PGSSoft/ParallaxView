//
//  ParallaxCollectionViewCell.swift
//  Jenkins
//
//  Created by Łukasz Śliwiński on 20/04/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import UIKit

public enum SubviewsParallaxType {
    /// maxParallaxOffset will be divided by the index of the subview inside `ParallaxView`.
    /// So view that is the last subview of the `ParallaxView` will be have the biggest offset equal to `maxParallaxOffset`
    case BasedOnHierarchyInParallaxView(maxParallaxOffset: Double)
    case BasedOnTag
    case None
}

protocol ParallaxableView {

    weak var parallaxContainerView: UIView! { get set }

    weak var glowEffectContainerView: UIView? { get set }

    var glowEffect: UIImageView { get }

    var parallaxEffect: ParallaxMotionEffect { get set }

    var subviewsParallaxType: SubviewsParallaxType { get set }

    var shadowPanDeviation: Double { get set }

    func setupUnfocusedState()

    func setupFocusedState()

    func beforeBecomeFocusedAnimation()

    func beforeResignFocusAnimation()

}

extension ParallaxableView {

    func setupUnfocusedState() {}

    func setupFocusedState() {}

    func beforeBecomeFocusedAnimation() {}

    func beforeResignFocusAnimation() {}

    static func loadGlowImage() -> UIImageView {
        if case let bundle = NSBundle(forClass: ParallaxView.self), let glowImage = UIImage(named: "gloweffect", inBundle: bundle, compatibleWithTraitCollection: nil) {
            return UIImageView(image: glowImage)
        } else {
            fatalError("Can't initialize gloweffect image")
        }
    }

}

extension ParallaxableView {

    func addParallaxMotionEffects() {
        var motionGroup = UIMotionEffectGroup()
        motionGroup.motionEffects = []

        // Cell parallax effect
        let parallaxMotionEffect = parallaxEffect

        motionGroup.motionEffects?.append(parallaxMotionEffect)

        if shadowPanDeviation != 0 {
            // Shadow effect
            let veriticalShadowEffect = UIInterpolatingMotionEffect(keyPath: "layer.shadowOffset.height", type: .TiltAlongVerticalAxis)
            veriticalShadowEffect.minimumRelativeValue = -shadowPanDeviation
            veriticalShadowEffect.maximumRelativeValue = shadowPanDeviation/2

            let horizontalShadowEffect = UIInterpolatingMotionEffect(keyPath: "layer.shadowOffset.width", type: .TiltAlongHorizontalAxis)
            horizontalShadowEffect.minimumRelativeValue = -shadowPanDeviation
            horizontalShadowEffect.maximumRelativeValue = shadowPanDeviation

            motionGroup.motionEffects?.appendContentsOf([veriticalShadowEffect, horizontalShadowEffect])
        }

        parallaxContainerView.addMotionEffect(motionGroup)

        if case .None = subviewsParallaxType {
        } else {
            parallaxContainerView.subviews
                .filter { $0 !== glowEffectContainerView }
                .enumerate()
                .forEach { (index: Int, subview: UIView) in
                    let relativePanValue: Double

                    switch subviewsParallaxType {
                    case .BasedOnHierarchyInParallaxView(let maxOffset):
                        relativePanValue = maxOffset / (Double(index+1))
                    case .BasedOnTag:
                        relativePanValue = Double(subview.tag)
                    default:
                        relativePanValue = 0.0
                    }

                    let verticalSubviewEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)

                    verticalSubviewEffect.minimumRelativeValue = -relativePanValue
                    verticalSubviewEffect.maximumRelativeValue = relativePanValue

                    let horizontalSubviewEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
                    horizontalSubviewEffect.minimumRelativeValue = -relativePanValue
                    horizontalSubviewEffect.maximumRelativeValue = relativePanValue

                    let group = UIMotionEffectGroup()
                    group.motionEffects = [verticalSubviewEffect, horizontalSubviewEffect]
                    subview.addMotionEffect(group)
            }
        }

        // Glow effect
        let verticalGlowEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        verticalGlowEffect.minimumRelativeValue = -glowEffect.frame.height
        verticalGlowEffect.maximumRelativeValue = parallaxContainerView.bounds.height+glowEffect.frame.height*1.1

        let horizontalGlowEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        horizontalGlowEffect.minimumRelativeValue = -parallaxContainerView.bounds.width+glowEffect.frame.width/4
        horizontalGlowEffect.maximumRelativeValue = parallaxContainerView.bounds.width-glowEffect.frame.width/4

        let glowMotionGroup = UIMotionEffectGroup()
        glowMotionGroup.motionEffects = [horizontalGlowEffect, verticalGlowEffect]

        glowEffect.addMotionEffect(glowMotionGroup)
    }

    func removeParallaxMotionEffects() {
        parallaxContainerView.motionEffects.removeAll()
        parallaxContainerView.subviews
            .filter { $0 !== glowEffectContainerView }
            .forEach { (subview: UIView) in
                subview.motionEffects.removeAll()
        }
        glowEffect.motionEffects.removeAll()
    }

}

public class ParallaxView: UIView, ParallaxableView {

    // MARK: Properties

    lazy var glowEffect: UIImageView = {
        return ParallaxView.loadGlowImage()
    }()

    /// View that will be a container for glow effect. If nil then glow effect will be not visible.
    public weak var glowEffectContainerView: UIView? {
        didSet {
            glowEffectContainerView?.layer.cornerRadius = layer.cornerRadius
            glowEffectContainerView?.clipsToBounds = true
            glowEffectContainerView?.addSubview(glowEffect)
            glowEffectContainerView?.opaque = true
            glowEffectContainerView?.layer.shouldRasterize = true
        }
    }

    /// View that will be used to manage parallaxEffect. Default it will be Self.
    public weak var parallaxContainerView: UIView!

    /// Specify parallax effect of subiviews of the `parallaxEffectView`.
    public var subviewsParallaxType: SubviewsParallaxType = .None

    /// Maximum deviation of the shadow relative to the center
    public var shadowPanDeviation = 15.0

    /**
     Property allow to customize parallax effect (pan, angles, etc.)

     - seealso:
     See field
     [ParallaxEffect.swift](ParallaxEffect.swift)

     */
    public var parallaxEffect = ParallaxMotionEffect()

    /// Alpha of the glow effect
    public var glowEffectAlpha = CGFloat(1.0) {
        didSet {
            glowEffect.alpha = glowEffectAlpha
        }
    }

    /// Corner radius for the view
    public var cornerRadius = CGFloat(10) {
        didSet {
            layer.cornerRadius = cornerRadius
            glowEffectContainerView?.layer.cornerRadius = layer.cornerRadius
        }
    }

    // MARK: Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)

        glowEffectContainerView = self

        commonInit()
        setupUnfocusedState()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        glowEffectContainerView = self

        commonInit()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        setupUnfocusedState()
    }

    public override func canBecomeFocused() -> Bool {
        return true
    }

    // MARK: UIView

    public override func layoutSubviews() {
        super.layoutSubviews()

        guard let glowEffectSuperViewBounds = glowEffectContainerView?.superview?.bounds else { return }

        let maxSize = max(glowEffectSuperViewBounds.width, glowEffectSuperViewBounds.height)
        // Make glow a litte bit bigger than cell
        glowEffect.frame = CGRect(x: 0, y: 0, width: maxSize*1.7, height: maxSize*1.7)
        // Position in the middle and under the top edge of the cell
        glowEffect.center = CGPoint(x: glowEffectSuperViewBounds.width/2, y: -glowEffect.frame.height*0.95)
    }

    // MARK: UIResponder

    public override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for press in presses {
            switch press.type {
            case .Select:
                UIView.animateWithDuration(0.1, animations: {
                    self.transform = CGAffineTransformMakeScale(0.95, 0.95)
                })
            default:
                super.pressesBegan(presses, withEvent: event)
            }
        }
    }

    public override func pressesCancelled(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for press in presses {
            switch press.type {
            case .Select:
                UIView.animateWithDuration(0.1, animations: {
                    if self.focused {
                        self.setupFocusedState()
                    } else {
                        self.setupUnfocusedState()
                    }
                })
            default:
                super.pressesCancelled(presses, withEvent: event)
            }
        }
    }

    public override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for press in presses {
            switch press.type {
            case .Select:
                UIView.animateWithDuration(0.2, animations: {
                    if self.focused {
                        self.transform = CGAffineTransformIdentity
                        self.setupFocusedState()
                    } else {
                        self.transform = CGAffineTransformIdentity
                        self.setupUnfocusedState()
                    }
                })
            default:
                super.pressesEnded(presses, withEvent: event)
            }
        }
    }

    public override func pressesChanged(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        super.pressesChanged(presses, withEvent: event)
    }

    // MARK: UIFocusEnvironment

    public override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)

        guard let nextFocusedView = context.nextFocusedView else { return }
        if nextFocusedView == self {
            // Add parallax effect to focused cell
            becomeFocusedUsingAnimationCoordinator(coordinator)
        } else {
            // Remove parallax effect
            resignFocusUsingAnimationCoordinator(coordinator)
        }
    }

    // MARK: Private

    internal func commonInit() {
        layer.cornerRadius = cornerRadius
        layer.shouldRasterize = true

        glowEffect.alpha = glowEffectAlpha

        parallaxContainerView = self
        parallaxContainerView.layer.shouldRasterize = true

    }

//    internal func addParallaxMotionEffects() {
//        var motionGroup = UIMotionEffectGroup()
//        motionGroup.motionEffects = []
//
//        // Cell parallax effect
//        let parallaxMotionEffect = parallaxEffect
//
//        motionGroup.motionEffects?.append(parallaxMotionEffect)
//
//        if shadowPanDeviation != 0 {
//            // Shadow effect
//            let veriticalShadowEffect = UIInterpolatingMotionEffect(keyPath: "layer.shadowOffset.height", type: .TiltAlongVerticalAxis)
//            veriticalShadowEffect.minimumRelativeValue = -shadowPanDeviation
//            veriticalShadowEffect.maximumRelativeValue = shadowPanDeviation/2
//
//            let horizontalShadowEffect = UIInterpolatingMotionEffect(keyPath: "layer.shadowOffset.width", type: .TiltAlongHorizontalAxis)
//            horizontalShadowEffect.minimumRelativeValue = -shadowPanDeviation
//            horizontalShadowEffect.maximumRelativeValue = shadowPanDeviation
//
//            motionGroup.motionEffects?.appendContentsOf([veriticalShadowEffect, horizontalShadowEffect])
//        }
//
//        parallaxEffectView?.addMotionEffect(motionGroup)
//
//        if case .None = subviewsParallaxType {
//        } else {
//            parallaxEffectView.subviews
//                .filter { $0 !== glowEffectContainerView }
//                .enumerate()
//                .forEach { [unowned self] (index: Int, subview: UIView) in
//                    let relativePanValue: Double
//
//                    switch self.subviewsParallaxType {
//                    case .BasedOnHierarchyInParallaxView(let maxOffset):
//                        relativePanValue = maxOffset / (Double(index+1))
//                    case .BasedOnTag:
//                        relativePanValue = Double(subview.tag)
//                    default:
//                        relativePanValue = 0.0
//                    }
//
//                    let verticalSubviewEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
//
//                    verticalSubviewEffect.minimumRelativeValue = -relativePanValue
//                    verticalSubviewEffect.maximumRelativeValue = relativePanValue
//
//                    let horizontalSubviewEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
//                    horizontalSubviewEffect.minimumRelativeValue = -relativePanValue
//                    horizontalSubviewEffect.maximumRelativeValue = relativePanValue
//
//                    let group = UIMotionEffectGroup()
//                    group.motionEffects = [verticalSubviewEffect, horizontalSubviewEffect]
//                    subview.addMotionEffect(group)
//            }
//        }
//
//
//
//        // Glow effect
//        let verticalGlowEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
//        verticalGlowEffect.minimumRelativeValue = -glowEffect.frame.height
//        verticalGlowEffect.maximumRelativeValue = bounds.height+glowEffect.frame.height*1.1
//
//        let horizontalGlowEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
//        horizontalGlowEffect.minimumRelativeValue = -bounds.width+glowEffect.frame.width/4
//        horizontalGlowEffect.maximumRelativeValue = bounds.width-glowEffect.frame.width/4
//
//        let glowMotionGroup = UIMotionEffectGroup()
//        glowMotionGroup.motionEffects = [horizontalGlowEffect, verticalGlowEffect]
//
//        glowEffect.addMotionEffect(glowMotionGroup)
//    }

//    internal func removeParallaxMotionEffects() {
//        parallaxEffectView?.motionEffects.removeAll()
//        parallaxEffectView.subviews
//            .filter { $0 !== glowEffectContainerView }
//            .forEach { (subview: UIView) in
//                subview.motionEffects.removeAll()
//        }
//        glowEffect.motionEffects.removeAll()
//    }

    internal func becomeFocusedUsingAnimationCoordinator(coordinator: UIFocusAnimationCoordinator) {
        beforeBecomeFocusedAnimation()

        coordinator.addCoordinatedAnimations({
            self.addParallaxMotionEffects()
            self.setupFocusedState()
            }, completion: nil)
    }

    internal func resignFocusUsingAnimationCoordinator(coordinator: UIFocusAnimationCoordinator) {
        beforeResignFocusAnimation()

        coordinator.addCoordinatedAnimations({
            self.removeParallaxMotionEffects()
            self.setupUnfocusedState()
            }, completion: nil)
    }

}
