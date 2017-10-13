//
//  ScreenObjectModel.swift
//  ExampleUITests
//
//  Created by Richard Moult on 12/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest


class ScreenObjectModel: ObjectModel {

    // MARK: - UI Elements

    var navigationTitle: XCUIElement {
        return app.navigationBars.element
    }

    // MARK: - UI Elements to identiy screen when navigating and waiting for screen to appear

    func screenIdentifyingElements() -> [XCUIElement] {
        return []
    }

    // MARK: - Verifications

    @discardableResult
    func waitForScreenAppearance(fileStatic: StaticString = #file, file: String = #file, line: UInt = #line) -> Self {
        for element in screenIdentifyingElements() {
            testCase.waitForElementToExist(element, waitSeconds: 10, file: file, line: line)
        }
        return self
    }


    @discardableResult
    func waitForScreenAppearanceToBeHitable(fileStatic: StaticString = #file, file: String = #file, line: UInt = #line) -> Self {
        for element in screenIdentifyingElements() {
            testCase.waitForElementToExistAndVisibleAndHittable(element, waitSeconds: 10, file: file, line: line)
        }
        return self
    }

    @discardableResult
    func waitForElement(element: XCUIElement, fileStatic: StaticString = #file, file: String = #file, line: UInt = #line) -> Self {
        testCase.waitForElementToExist(element, waitSeconds: 10, file: file, line: line)
        return self
    }

    @discardableResult
    func verifyNavigationTitle(_ title: String, file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertEqual(navigationTitle.identifier, title)
        return self
    }


}

