//
//  SubviewsParallaxType.swift
//
//  Created by Łukasz Śliwiński on 10/05/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import Foundation

public enum SubviewsParallaxType {
    /// maxParallaxOffset will be divided by the index of the subview inside `ParallaxView`.
    /// So view that is the last subview of the `ParallaxView` will be have the biggest offset equal to `maxParallaxOffset`
    case BasedOnHierarchyInParallaxView(maxParallaxOffset: Double)
    /// Tag value will be used as maximum offset for parallax effect
    case BasedOnTag
    case None
}
