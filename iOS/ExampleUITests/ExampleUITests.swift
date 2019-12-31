//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest

class ExampleUITests: UITestCase {

    // Just a rough idea of a UI test could be

    // Sometimes UI test are best served testing functionality rather than data, e.g. "make sure feature is present and working correctly", not "title of movie is correct"
    // UI tests tend to be some of the more unstable tests due to apps that have ever evolving UI, so this form
    // of UI testing archetecture works well to give a high level understanding of what the test flow is, supported
    // by ScreenModels that contain only the actions they have available for each ViewController

    // We should aim to not pimarily rely on UI tests, the bulk of our tests should primarly be lower down in
    // the stack, focused and fast, like unit and ViewController integrated tests then supported by a smaller number of higher level/broad tests such as UI tests.

    // There are other kinds of UI tests, check out snap shot testing https://github.com/uber/ios-snapshot-test-case/
    // this is great for checking visual elements, e.g aligments, visibility etc

    // Check out Acceptance testing for quick app logic testing
    // Fitnesse http://fitnesse.org
    // Cucumberish https://github.com/Ahmed-Ali/Cucumberish
    // The above are external tools which may well require maintainence on xcode upgrades so best avoided for small team
    // Plain XCTAssert can also work well here instead of the above tools

    func test_userCanNavigate_fromAssetTypeSelectionToAssetDetailsAndBack() {

        launchApp()

        AssetTypeSelectionScreenModel(context: context)
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

        AssetTypeSelectionScreenModel(context: context)

            // wait for home view and then select search button
            .waitForScreenAppearanceToBeHitable()
            .verify(navigationTitle: "Selection")
            .navigateToSearchCollectionByTappingButton()

            // AssetSearchViewControllerModel
            // wait for search view enter text and navigate to details view
            .waitForScreenAppearanceToBeHitable()
            .verify(navigationTitle: "Search")
            .enterSearchText("random text")
            .waitForCollectionViewCellsToBecomeHittable()
            .navigateToAssetDetailsByTappingCell(atIndex: 0)

            // AssetDetailsScreenObjectModel
            // wait for details view to appear and back up to search
            .waitForScreenAppearance()
            .verify(navigationTitle: "Details")
            .tapBackButtonToSearch()

            // AssetSearchViewControllerModel
            // delete search text to remove all results and backup to home
            .waitForScreenAppearanceToBeHitable()
            .deleteSearchText()
            .verifyNoCellsShowing()
            .tapCancelButton()
            .tapBackButton()

            // AssetTypeSelectionViewControllerModel
            // wait for Home view to appear
            .waitForScreenAppearanceToBeHitable()
            .verify(navigationTitle: "Selection")
    }

    
}
