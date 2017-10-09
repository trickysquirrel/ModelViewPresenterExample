//
//  StubConfigureCollectionView.swift
//  ExampleTests
//
//  Created by Richard Moult on 10/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example


class StubConfigureCollectionView: CollectionViewConfigurable {

    private(set) var didCallConfigure = false

    func configure(collectionView: UICollectionView?, nibName: String, reuseIdentifier: String) {
        didCallConfigure = true
    }
}

