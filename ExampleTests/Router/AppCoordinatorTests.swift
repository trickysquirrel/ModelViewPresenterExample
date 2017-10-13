//
//  AppCoordinatorTests.swift
//  ExampleTests
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
        let adobeAnalyticsReporter = StubAdobeAnalyticsReporter()
        let analyticsReporterFactory = AnalyticsReporterFactory(adobeAnalyticsReporter: adobeAnalyticsReporter)
        let viewControllerFactory = ViewControllerFactory(iflixServiceFactory: StubBackendServiceFactory(), analyticsFactory: analyticsReporterFactory)
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

    func test_performShowDetailsAppAction_addCorrectViewControllerToNavigationController() {
        UIView.setAnimationsEnabled(false)
        appCoordinator.showRootViewController()
        let viewController = navigationController.viewControllers[0] as! AssetCollectionViewController
        viewController.appActions.showDetails(id: 0)
        XCTAssertEqual(navigationController.viewControllers.count, 2)
    }
}
