//
//  SkipFirstOffsetInterpolatingMotionEffect.swift
//  ParallaxView tvOS
//
//  Created by Łukasz Śliwiński on 24/06/2020.
//

import UIKit

internal final class SkipFirstOffsetInterpolatingMotionEffectDecorator: UIMotionEffect {

    private let decoratee: UIMotionEffect
    private var motionDidNotStart: Bool = true

    init(decoratee: UIMotionEffect) {
        self.decoratee = decoratee
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func keyPathsAndRelativeValues(forViewerOffset viewerOffset: UIOffset) -> [String : Any]? {
        defer { motionDidNotStart = false }

        if motionDidNotStart, viewerOffset.horizontal + viewerOffset.vertical != 0 {
            return nil
        }
        
        return decoratee.keyPathsAndRelativeValues(forViewerOffset: viewerOffset)
    }
}

internal extension UIMotionEffect {

    func decorateWithSkipFirstOffset() -> UIMotionEffect {
        return SkipFirstOffsetInterpolatingMotionEffectDecorator(decoratee: self)
    }
}
