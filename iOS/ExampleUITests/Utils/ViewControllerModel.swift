//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest


class ViewControllerModel {

    var parent: ViewControllerModel?

    let context: UITestContext

    var app: XCUIApplication {
        return context.app
    }

    var testCase: UITestCase {
        return context.testCase
    }

    @discardableResult
    init(context: UITestContext, parent: ViewControllerModel? = nil) {
        self.context = context
        self.parent = parent
    }

    // MARK: - UI Elements

    var navigationTitle: XCUIElement {
        return app.navigationBars.element
    }

    var navigationBackButton: XCUIElement {
        return app.navigationBars.buttons.element(boundBy: 0)
    }

    // MARK: - UI Elements to identiy screen when navigating and waiting for screen to appear

    func screenIdentifyingElements() -> [XCUIElement] {
        return []
    }

    // MARK: Verifications

    @discardableResult
    func waitForScreenAppearance(file: String = #file, line: UInt = #line) -> Self {
        for element in screenIdentifyingElements() {
            testCase.waitForElementToExist(element, waitSeconds: 10, file: file, line: line)
        }
        return self
    }

    @discardableResult
    func waitForScreenAppearanceToBeHitable(file: String = #file, line: UInt = #line) -> Self {
        for element in screenIdentifyingElements() {
            testCase.waitForElementToExistAndVisibleAndHittable(element, waitSeconds: 10, file: file, line: line)
        }
        return self
    }

    @discardableResult
    func waitForElementToExist(element: XCUIElement, file: String = #file, line: UInt = #line) -> Self {
        testCase.waitForElementToExist(element, waitSeconds: 10, file: file, line: line)
        return self
    }

    @discardableResult
    func waitForElementToBeHittable(element: XCUIElement, fileStatic: StaticString = #file, file: String = #file, line: UInt = #line) -> Self {
        testCase.waitForElementToExistAndVisibleAndHittable(element, waitSeconds: 10, file: file, line: line)
        return self
    }

    @discardableResult
    func verify(navigationTitle title: String, file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertEqual(navigationTitle.identifier, title, file: file, line: line)
        return self
    }

    @discardableResult
    func verify(keyboardIsShown: Bool, file: StaticString = #file, line: UInt = #line) -> Self {
        if keyboardIsShown {
            XCTAssert(app.keyboards.count > 0, "The keyboard is not showing", file: file, line: line)
        }
        else {
            XCTAssert(app.keyboards.count == 0, "The keyboard is showing", file: file, line: line)
        }
        return self
    }


    // MARK: Actions

    @discardableResult
    func tapBackButton(file: StaticString = #file, line: UInt = #line) -> ViewControllerModel {
        navigationBackButton.tap()
        XCTAssertNotNil(parent, "screen object does not have parent to back up to", file: file, line: line)
        return parent!
    }
}

