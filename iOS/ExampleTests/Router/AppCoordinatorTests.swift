//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example


class AppCoordinatorTests: XCTestCase {

    var window: UIWindow!
    var navigationController: UINavigationController!
    var appCoordinator: AppRouter!
    var stubAlert: StubInformationAlert!

    override func setUp() {
        super.setUp()
        window = UIWindow()
        navigationController = UINavigationController()
        stubAlert = StubInformationAlert()
        let stubAnalyticsReporter = StubThirdPartyAnalyticsReporter()
        let analyticsReporterFactory = AnalyticsReporterFactory(reporter: stubAnalyticsReporter)
        let viewControllerFactory = ViewControllerFactory(analyticsFactory: analyticsReporterFactory)
        appCoordinator = AppRouter(window: window,
                                   navigationController: navigationController,
                                   viewControllerFactory: viewControllerFactory,
                                   informationAlert: stubAlert,
                                   animateTransitions: false)
    }


    override func tearDown() {
        stubAlert = nil
        appCoordinator = nil
        navigationController = nil
        window = nil
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
        XCTAssertTrue(navigationController.viewControllers[0] is HomeViewController)
    }

    func test_showAssetCollection_showsAssetCollectionViewToUser() {
        appCoordinator.start()
        appCoordinator.showMoviesCollection()
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertTrue(navigationController.viewControllers[1] is AssetCollectionViewController)
    }

    func test_showAssetDetails_showsAssetDetailsViewToUser() {
        appCoordinator.start()
        appCoordinator.showDetails(id: "1", title: "title")
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertTrue(navigationController.viewControllers[1] is AssetDetailsViewController)
    }

    func test_showAlertOk_callsInformationAlertToDisplayInfo() {
        appCoordinator.start()
        let currentViewController = navigationController.viewControllers.last!
        appCoordinator.showAlertOK(title: "title", msg: "message", presentingViewController: currentViewController)
        XCTAssertEqual(stubAlert.title, "title")
        XCTAssertEqual(stubAlert.message, "message")
        XCTAssertEqual(stubAlert.presentingViewController, currentViewController)
    }
}

