//
//  SubviewsParallaxType.swift
//
//  Created by Łukasz Śliwiński on 10/05/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import Foundation

public enum SubviewsParallaxMode {
    /// maxParallaxOffset will be divided by the index of the subview inside `ParallaxView`.
    /// So view that is the last subview of the `ParallaxView` will be have the biggest offset equal to `maxParallaxOffset`

    /**
     *  Subview deeper on the hierarchy moves more depending on its index.
     *
     *  @param Double Deepest view on the hierarchy will have this maximum movement offset
     *  @param Double Jump between successive values can be adjusted by multipler. Param is optional, default it will be equal to 1.0
     */
    case basedOnHierarchyInParallaxView(maxParallaxOffset: Double, multipler: Double?)
    /// Tag value will be used as maximum offset for parallax effect of the subview.
    /// Each view can be individually adjusted by the tag property
    case basedOnTag
    /// No parallax animation will be added to subviews of the parallax view
    case none
}
