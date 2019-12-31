//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example

class AssetCollectionScreenModel: ViewControllerScreenModel {

    // MARK: - UI Elements

    private var collectionView: XCUIElement {
        return app.collectionViews[Accessibility.assetCollectionView.id]
    }

    private func cellAtIndex(_ index: Int) -> XCUIElement {
        return collectionView.cells.element(boundBy: index)
    }

    // MARK: - UI Elements to identiy screen when navigating and waiting for screen to appear

    override func screenIdentifyingElements() -> [XCUIElement] {
        return [collectionView]
    }

    // MARK: Verifications

    
    // MARK: Actions

    @discardableResult
    func navigateToAssetDetailsByTappingCell(atIndex index: Int, fileStatic: StaticString = #file, file: String = #file, line: UInt = #line) -> AssetDetailsScreenModel {
        let cell = cellAtIndex(index)
        XCTAssertTrue(cell.exists, "asset collection cell not found", file: fileStatic, line: line)
        cell.tap()
        return AssetDetailsScreenModel(context: context, parent: self)
    }

}
