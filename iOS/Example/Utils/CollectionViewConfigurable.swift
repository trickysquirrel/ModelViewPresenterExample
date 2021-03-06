//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit


protocol CollectionViewConfigurable {
    func configure(collectionView: UICollectionView?, nibName: String, reuseIdentifier: String, accessId: String)
}


struct ConfigureCollectionView: CollectionViewConfigurable {

    func configure(collectionView: UICollectionView?, nibName: String, reuseIdentifier: String, accessId: String) {

        let nib = UINib.init(nibName: nibName, bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        let collectionViewLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewLayout?.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        collectionViewLayout?.invalidateLayout()

        setAccessibility(collectionView: collectionView, accessId: accessId)
    }

    
    private func setAccessibility(collectionView: UICollectionView?, accessId: String) {
        collectionView?.accessibilityIdentifier = accessId
    }

}
