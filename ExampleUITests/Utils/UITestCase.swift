//
//  Created by Richard Moult on 12/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation

import XCTest


typealias UITestContext = (app: XCUIApplication, testCase: UITestCase)

class UITestCase : XCTestCase {

    private(set) var app: XCUIApplication!

    var context: UITestContext {
        return (app: app, testCase: self)
    }

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    override func tearDown() {
        XCUIApplication().terminate()
        super.tearDown()
    }

    func launchApp() {
        app = XCUIApplication()

        // add in launch arguments here
        // app.launchArguments = ["AUTOMATION_TESTS"]

        // add in launch enviroment
        // var launchEnvironment: [String: String] = [:]
        // launchEnvironment["CURRENTLOCATION_SYSTEM_ALERT_OFF"] = "1"
        // app.launchEnvironment = launchEnvironment

        app.launch()
    }

    // Wait for an element to exist and be hittable (visible and on screen)
    func waitForElementToExistAndVisibleAndHittable(_ element: XCUIElement, waitSeconds: TimeInterval = 10, file: String, line: UInt) {

        let existsPredicate = NSPredicate(format: "hittable == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)

        waitForExpectations(timeout: waitSeconds) { error in
            if error != nil {
                let message = "Failed to find \(element) after waiting \(waitSeconds) seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: Int(line), expected: true)
            }
        }
    }


    func waitForElementToExist(_ element: XCUIElement, waitSeconds: TimeInterval = 10.0, file: String, line: UInt) {

        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)

        waitForExpectations(timeout: waitSeconds) { error in
            if error != nil {
                let message = "Failed to find \(element) after waiting \(waitSeconds) seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: Int(line), expected: true)
            }
        }
    }



}
