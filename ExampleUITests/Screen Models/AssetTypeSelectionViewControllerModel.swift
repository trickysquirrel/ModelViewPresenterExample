//
//  AssetTypeSelectionViewControllerModel.swift
//  ExampleUITests
//
//  Created by Richard Moult on 15/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation

//
//  Created by Richard Moult on 12/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example

class AssetTypeSelectionViewControllerModel: ViewControllerModel {

    // MARK: - UI Elements

    private var moviesButton: XCUIElement {
        return app.buttons[Access.selectionMoviesButton.id]
    }

    private var searchButton: XCUIElement {
        return app.buttons[Access.selectionSearchButton.id]
    }

    // MARK: - UI Elements to identiy screen when navigating and waiting for screen to appear

    override func screenIdentifyingElements() -> [XCUIElement] {
        return [moviesButton]
    }

    // MARK: Verifications


    // MARK: Actions

    @discardableResult
    func navigateToMovieCollectionByTappingButton(fileStatic: StaticString = #file, file: String = #file, line: UInt = #line) -> AssetCollectionViewControllerModel {
        XCTAssertTrue(moviesButton.exists, "movies button does not exist", file: fileStatic, line: line)
        XCTAssertTrue(moviesButton.isHittable, "movies button is not selectable", file: fileStatic, line: line)
        moviesButton.tap()
        return AssetCollectionViewControllerModel(context: context, parent: self)
    }

    func navigateToSearchCollectionByTappingButton(fileStatic: StaticString = #file, file: String = #file, line: UInt = #line) -> AssetSearchViewControllerModel {
        XCTAssertTrue(searchButton.exists, "movies button does not exist", file: fileStatic, line: line)
        XCTAssertTrue(searchButton.isHittable, "movies button is not selectable", file: fileStatic, line: line)
        searchButton.tap()
        return AssetSearchViewControllerModel(context: context, parent: self)
    }

}
