//
//  AssetDetailsScreenObjectModel.swift
//  ExampleUITests
//
//  Created by Richard Moult on 13/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example

class AssetDetailsScreenObjectModel: ScreenObjectModel {

    // MARK: - UI Elements

    private var view: XCUIElement {
        return app.collectionViews[Access.assetDetailsView.id]
    }

    // MARK: - UI Elements to identiy screen when navigating and waiting for screen to appear

    override func screenIdentifyingElements() -> [XCUIElement] {
        return [view]
    }

    // MARK: verifications


    // MARK: actions

}

