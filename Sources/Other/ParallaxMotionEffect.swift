//
//  ParallaxMotionEffect.swift
//
//  Created by Łukasz Śliwiński on 20/04/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import UIKit

open class ParallaxMotionEffect: UIMotionEffect {

    // MARK: Properties

    /// How far camera is from the object
    open var cameraPositionZ = CGFloat(0)

    /// The maximum angle horizontally
    open var viewingAngleX = CGFloat(Double.pi/4/8)

    /// The maximum angle vertically
    open var viewingAngleY = CGFloat(Double.pi/4/8)

    /// Maximum deviation relative to the center
    open var panValue = CGFloat(8)

    /// Perspective value. The closer is to 0 the deepest is the perspective
    open var m34 = CGFloat(-1.0/700)

    // MARK: UIMotionEffect

    override open func keyPathsAndRelativeValues(forViewerOffset viewerOffset: UIOffset) -> [String : Any]? {
        var transform = CATransform3DIdentity
        transform.m34 = m34

        var newViewerOffset = viewerOffset
        newViewerOffset.horizontal = newViewerOffset.horizontal <= -1.0 ? -1.0 : newViewerOffset.horizontal
        newViewerOffset.vertical = newViewerOffset.vertical <= -1.0 ? -1.0 : newViewerOffset.vertical

        transform = CATransform3DTranslate(transform, panValue*newViewerOffset.horizontal, panValue*newViewerOffset.vertical, cameraPositionZ)

        transform = CATransform3DRotate(transform, viewingAngleX * newViewerOffset.vertical, 1, 0, 0)
        transform = CATransform3DRotate(transform, viewingAngleY * -newViewerOffset.horizontal, 0, 1, 0)

        return ["layer.transform": NSValue(caTransform3D: transform)]
    }

}
