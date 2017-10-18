//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example


class StubConfigureCollectionView: CollectionViewConfigurable {

    private(set) var didCallConfigure = false

    func configure(collectionView: UICollectionView?, nibName: String, reuseIdentifier: String, accessId: String) {
        didCallConfigure = true
    }
}

