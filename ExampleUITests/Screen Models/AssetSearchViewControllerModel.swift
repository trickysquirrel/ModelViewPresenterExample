//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example

class AssetSearchViewControllerModel: ViewControllerModel {

    // MARK: - UI Elements

    private var searchBar: XCUIElement {
        return app.otherElements[Access.searchBar.id]
    }

    private var searchBarClearButton: XCUIElement {
        return searchBar.buttons.element(boundBy: 0)
    }

    private var loadingView: XCUIElement {
        return app.otherElements[Access.loadingView.id]
    }

    private var collectionView: XCUIElement {
        return app.collectionViews[Access.searchCollectionView.id]
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
    func waitForLoadingViewToAppear(fileStatic: StaticString = #file, file: String = #file, line: UInt = #line) -> Self {
        waitForElementToExist(element: loadingView)
        return self
    }

    @discardableResult
    func waitForCollectionViewCellsToBecomeHittable(fileStatic: StaticString = #file, file: String = #file, line: UInt = #line) -> Self {
        waitForElementToBeHittable(element: collectionView)
        waitForElementToBeHittable(element: cellAtIndex(0))
        return self
    }

    @discardableResult
    func verifyLoadingViewHidden(fileStatic: StaticString = #file, file: String = #file, line: UInt = #line) -> Self {
        XCTAssertFalse(loadingView.exists, file: fileStatic, line: line)
        return self
    }

    @discardableResult
    func verifyNoCellsShowing(fileStatic: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertFalse(cellAtIndex(0).exists, file: fileStatic, line: line)
        return self
    }

    // MARK: Actions

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

