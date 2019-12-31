//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example

class AssetSearchScreenModel: ViewControllerScreenModel {

    // MARK: - UI Elements

    private var searchBar: XCUIElement {
        return app.searchFields.element(boundBy: 0)
    }

    private var searchBarClearButton: XCUIElement {
        return searchBar.buttons.element(boundBy: 0)
    }

    private var collectionView: XCUIElement {
        return app.collectionViews[Accessibility.assetCollectionView.id]
    }

    private func cellAtIndex(_ index: Int) -> XCUIElement {
        return collectionView.cells.element(boundBy: index)
    }


    // MARK: - UI Elements to identiy screen when navigating and waiting for screen to appear

    override func screenIdentifyingElements() -> [XCUIElement] {
        return []
    }

    // MARK: Verifications

    @discardableResult
    func waitForCollectionViewCellsToBecomeHittable(fileStatic: StaticString = #file, file: String = #file, line: UInt = #line) -> Self {
        waitForElementToBeHittable(element: collectionView, file: file, line: line)
        waitForElementToBeHittable(element: cellAtIndex(0), file: file, line: line)
        return self
    }

    @discardableResult
    func verifyNoCellsShowing(fileStatic: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertFalse(cellAtIndex(0).exists, file: fileStatic, line: line)
        return self
    }

    // MARK: Actions

    @discardableResult
    func navigateToAssetDetailsByTappingCell(atIndex index: Int, fileStatic: StaticString = #file, file: String = #file, line: UInt = #line) -> AssetDetailsScreenModel {
        let cell = cellAtIndex(index)
        XCTAssertTrue(cell.exists, "asset collection cell not found", file: fileStatic, line: line)
        cell.tap()
        return AssetDetailsScreenModel(context: context, parent: self)
    }

    @discardableResult
    func enterSearchText(_ searchText: String, fileStatic: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertTrue(searchBar.exists, "search bar not found", file: fileStatic, line: line)
        searchBar.tap()
        searchBar.typeText(searchText)
        return self
    }

    @discardableResult
    func deleteSearchText(fileStatic: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertTrue(searchBarClearButton.exists, file: fileStatic, line: line)
        searchBarClearButton.tap()
        return self
    }

    @discardableResult
    func tapCancelButton() -> Self {
        let element = app.buttons["Cancel"] // en lang only now
        element.tap()
        return self
    }

}

