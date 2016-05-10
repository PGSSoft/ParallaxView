//
//  CollectionViewController.swift
//  ParallaxViewExample
//
//  Created by Łukasz Śliwiński on 09/05/16.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {

    // MARK: Properties

    let numberOfItemsPerRow = 3
    let numberOfRows = 3

    // MARK: Outlets

    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: UIViewController

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        configureFlowLayoutSpacing()
    }

    // MARK: Convenience

    func configureFlowLayoutSpacing() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let maxWidthOfOneItem = collectionView.frame.width / CGFloat(numberOfItemsPerRow)
            let inset = maxWidthOfOneItem * 0.1

            flowLayout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
            flowLayout.minimumLineSpacing = inset
            flowLayout.minimumInteritemSpacing = inset
        }
    }

}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            let totalSpaceWidth = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
            let width = Int((collectionView.bounds.width - totalSpaceWidth) / CGFloat(numberOfItemsPerRow))

            let totalSpaceHeight = flowLayout.sectionInset.top
                + flowLayout.sectionInset.bottom
                + (flowLayout.minimumLineSpacing * CGFloat(numberOfRows - 1))
            let height = Int((collectionView.bounds.height - totalSpaceHeight) / CGFloat(numberOfRows))

            return CGSize(width: width, height: height)
        }

        fatalError("collectionViewLayout is not UICollectionViewFlowLayout")
    }

}

extension CollectionViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfRows * numberOfItemsPerRow
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)

        return cell
    }

}
