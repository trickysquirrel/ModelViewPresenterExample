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

    // MARK: - UI Elements to identiy screen when navigating and waiting for screen to appear

    func screenIdentifyingElements() -> [XCUIElement] {
        return []
    }

    // MARK: - Verifications

    @discardableResult
    func waitForScreenAppearance(fileStatic: StaticString = #file, file: String = #file, line: UInt = #line) -> Self {
        guard !screenIdentifyingElements().isEmpty else {
            XCTFail("Screen identifying elements array cannot be empty", file: fileStatic, line: line)
            return self
        }

        for element in screenIdentifyingElements() {
            testCase.waitForElementToExistAndVisibleAndOnScreen(element, waitSeconds: 10, file: file, line: line)
        }
        return self
    }

}

