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

    private func cellAtIndex(_ index: Int) -> XCUIElement {
        return collectionView.cells.element(boundBy: index)
    }

    // MARK: - UI Elements to identiy screen when navigating and waiting for screen to appear

    override func screenIdentifyingElements() -> [XCUIElement] {
        return [collectionView]
    }

    // MARK: verifications

    // MARK: actions

    @discardableResult
    func navigateToAssetDetailsByTappingCell(atIndex index: Int, fileStatic: StaticString = #file, file: String = #file, line: UInt = #line) -> AssetDetailsScreenObjectModel {
        let cell = cellAtIndex(index)
        XCTAssertTrue(cell.exists, "asset collection cell not found", file: fileStatic, line: line)
        cell.tap()
        return AssetDetailsScreenObjectModel(context: context, parent: self)
    }

}
