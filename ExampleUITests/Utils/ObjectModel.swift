//
//  ObjectModel.swift
//  ExampleUITests
//
//  Created by Richard Moult on 12/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest

class ObjectModel {

    let context: UITestContext

    var app: XCUIApplication {
        return context.app
    }

    var testCase: UITestCase {
        return context.testCase
    }

    @discardableResult
    init(context: UITestContext) {
        self.context = context
    }

}
