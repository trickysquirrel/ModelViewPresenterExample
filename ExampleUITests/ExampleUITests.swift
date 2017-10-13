//
//  ExampleUITests.swift
//  ExampleUITests
//
//  Created by Richard Moult on 12/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest

class ExampleUITests: UITestCase {

    // just a rough idea of a UI test
    // Sometimes UI test are best served testing functionality rather than data, e.g. "make sure feature is present and working correctly", not "title of movie is correct"

    // We should aim to not need UI tests, we need to first check out other tools that are faster (much faster)
    // Check out facebooks snap shot testing https://github.com/facebook/ios-snapshot-test-case
    // this is great for checking visual element, e.g visual elments, aligments, visibility etc

    // Check out Acceptance testing for quick app logic testing
    // Fitnesse http://fitnesse.org
    // Cucumberish https://github.com/Ahmed-Ali/Cucumberish
    // The above are external tools which may well require maintainence on xcode upgrades
    // Plain XCTAssert can also work well here instead of the above tools


    func test_movieCollection_showsAndSelectsItems() {

        launchApp()

        AssetCollectionScreenObjectModel(context: context)
            .waitForScreenAppearanceToBeHitable()
            .verifyNavigationTitle("Movies")
            .navigateToAssetDetailsByTapCell(atIndex: 0)
            //.waitForScreenAppearance()
            //.verifyNavigationTitle("Details")
    }

    
}
