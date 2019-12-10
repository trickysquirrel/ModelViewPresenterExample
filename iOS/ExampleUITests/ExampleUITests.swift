//
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


    func test_userCanNavigate_fromAssetTypeSelectionToAssetDetailsAndBack() {

        launchApp()

        AssetTypeSelectionViewControllerModel(context: context)
            .waitForScreenAppearanceToBeHitable()
            .verify(navigationTitle: "Selection")
            .navigateToMovieCollectionByTappingButton()

            // AssetCollectionViewControllerModel
            .waitForScreenAppearanceToBeHitable()
            .verify(navigationTitle: "Movies")
            .navigateToAssetDetailsByTappingCell(atIndex: 0)

            // AssetDetailsScreenObjectModel
            .waitForScreenAppearance()
            .verify(navigationTitle: "Details")
            .tapBackButton()

            // AssetCollectionViewControllerModel
            .waitForScreenAppearanceToBeHitable()
            .verify(navigationTitle: "Movies")
            .tapBackButton()

            // AssetTypeSelectionViewControllerModel
            .waitForScreenAppearanceToBeHitable()
            .verify(navigationTitle: "Selection")
    }


    func test_canUserSearchForAssets() {

        launchApp()

        AssetTypeSelectionViewControllerModel(context: context)
            .waitForScreenAppearanceToBeHitable()
            .verify(navigationTitle: "Selection")
            .navigateToSearchCollectionByTappingButton()

            // AssetSearchViewControllerModel
            .waitForScreenAppearanceToBeHitable()
            .verify(navigationTitle: "Search")
            .enterSearchText("random text")
            .waitForLoadingViewToAppear()
            .waitForCollectionViewCellsToBecomeHittable()
            .verifyLoadingViewHidden()
            .verify(keyboardIsShown: true)
            .deleteSearchText()
            .verifyNoCellsShowing()
            .verify(keyboardIsShown: false)
            .tapBackButton()

            // AssetTypeSelectionViewControllerModel
            .waitForScreenAppearanceToBeHitable()
            .verify(navigationTitle: "Selection")

    }

    
}