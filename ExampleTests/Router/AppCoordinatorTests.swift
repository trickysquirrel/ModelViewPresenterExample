//
//  Created by Richard Moult on 13/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example


class AppCoordinatorTests: XCTestCase {

    var window: UIWindow!
    var navigationController: UINavigationController!
    var appCoordinator: AppCoordinator!

    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        navigationController = UINavigationController()
        let stubAnalyticsReporter = StubThirdPartyAnalyticsReporter()
        let analyticsReporterFactory = AnalyticsReporterFactory(thirdPartyAnalyticsReporter: stubAnalyticsReporter)
        let viewControllerFactory = ViewControllerFactory(getDataServiceFactory: StubGetDataServiceFactory(), analyticsFactory: analyticsReporterFactory)
        appCoordinator = AppCoordinator(window: window, navigationController: navigationController, viewControllerFactory: viewControllerFactory)
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
        appCoordinator.showRootViewController()
        XCTAssertEqual(window.rootViewController, navigationController)
    }

    func test_showRootViewController_showsAssetCollectionViewToUser() {
        appCoordinator.showRootViewController()
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers[0] is AssetCollectionViewController)
    }

    // not ideal perhaps we should have a coordinator for each view controller, much easier to test
    func test_performShowDetailsAppAction_addCorrectViewControllerToNavigationController() {
        UIView.setAnimationsEnabled(false)
        appCoordinator.showRootViewController()
        let viewController = navigationController.viewControllers[0] as! AssetCollectionViewController
        viewController._appActions.showDetails(id: 0)
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertTrue(navigationController.viewControllers[1] is AssetDetailsViewController)
    }
}
