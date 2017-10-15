//
//  Created by Richard Moult on 13/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example


class AppCoordinatorTests: XCTestCase {

    var window: UIWindow!
    var navigationController: UINavigationController!
    var appCoordinator: RootAppCoordinator!


    override func setUp() {
        super.setUp()
        window = UIWindow()
        navigationController = UINavigationController()
        let stubAnalyticsReporter = StubThirdPartyAnalyticsReporter()
        let analyticsReporterFactory = AnalyticsReporterFactory(thirdPartyAnalyticsReporter: stubAnalyticsReporter)
        let viewControllerFactory = ViewControllerFactory(getDataServiceFactory: StubGetDataServiceFactory(), analyticsFactory: analyticsReporterFactory)
        appCoordinator = RootAppCoordinator(window: window, navigationController: navigationController, viewControllerFactory: viewControllerFactory)
    }


    override func tearDown() {
        window = nil
        navigationController = nil
        appCoordinator = nil
        super.tearDown()
    }
}


extension AppCoordinatorTests {

    func test_showRootViewController_addsNavigationControllerToWindowRoot() {
        appCoordinator.start()
        XCTAssertEqual(window.rootViewController, navigationController)
    }

    func test_showRootViewController_showsAssetCollectionViewToUser() {
        appCoordinator.start()
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers[0] is AssetTypeSelectionViewController)
    }

    func test_showAssetCollection_showsAssetCollectionViewToUser() {
        appCoordinator.start()
        appCoordinator.showMoviesCollection()
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertTrue(navigationController.viewControllers[1] is AssetCollectionViewController)
    }

    func test_showAssetDetails_showsAssetDetailsViewToUser() {
        appCoordinator.start()
        appCoordinator.showDetails(id: 1)
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertTrue(navigationController.viewControllers[1] is AssetDetailsViewController)
    }

    // TODO: after refactor missing test for show alert

}

