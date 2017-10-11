//
//  AssetCollectionScreenObjectModel.swift
//  ExampleUITests
//
//  Created by Richard Moult on 12/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example

class AssetCollectionScreenObjectModel: ScreenObjectModel {

    // MARK: - UI Elements

    private var collectionView: XCUIElement {
        return app.collectionViews[Access.assetCollectionView.id]
    }


    // MARK: - UI Elements to identiy screen when navigating and waiting for screen to appear

    override func screenIdentifyingElements() -> [XCUIElement] {
        return [collectionView]
    }

}
