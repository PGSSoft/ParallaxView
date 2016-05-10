//
//  CollectionViewCell.swift
//  ParallaxViewExample
//
//  Created by Łukasz Śliwiński on 09/05/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import UIKit
import ParallaxView

class CollectionViewCell: ParallaxCollectionViewCell {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.cornerRadius = 5
    }
}
