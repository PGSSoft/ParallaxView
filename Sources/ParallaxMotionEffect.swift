//
//  ParallaxMotionEffect.swift
//  Jenkins
//
//  Created by Łukasz Śliwiński on 20/04/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import UIKit

class ParallaxMotionEffect: UIMotionEffect {
    
    // MARK: Properties
    
    /// How far camera is from the object
    var cameraPositionZ = CGFloat(0)
    
    /// The maximum angle horizontally
    var viewingAngleX = CGFloat(M_PI_4/8)
    
    /// The maximum angle vertically
    var viewingAngleY = CGFloat(M_PI_4/8)
    
    /// Maximum deviation relative to the center
    var panValue = CGFloat(8)
    
    /// Perspective value. The closer is to 0 the deepest is the perspective
    var m34 = CGFloat(-1.0/700)
    
    // MARK: UIMotionEffect
    
    override func keyPathsAndRelativeValuesForViewerOffset(viewerOffset: UIOffset) -> [String : AnyObject]? {
        var transform = CATransform3DIdentity
        transform.m34 = m34
        
        var newViewerOffset = viewerOffset
        newViewerOffset.horizontal = newViewerOffset.horizontal <= -1.0 ? -1.0 : newViewerOffset.horizontal
        newViewerOffset.vertical = newViewerOffset.vertical <= -1.0 ? -1.0 : newViewerOffset.vertical
        
        transform = CATransform3DTranslate(transform, panValue*newViewerOffset.horizontal, panValue*newViewerOffset.vertical, cameraPositionZ)
        
        transform = CATransform3DRotate(transform, viewingAngleX * newViewerOffset.vertical, 1, 0, 0)
        transform = CATransform3DRotate(transform, viewingAngleY * -newViewerOffset.horizontal, 0, 1, 0)
        
        return ["layer.transform": NSValue(CATransform3D: transform)]
    }
    
}
