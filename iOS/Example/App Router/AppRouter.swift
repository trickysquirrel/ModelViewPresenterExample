//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit

protocol HomeRouterActions: class {
    func showMoviesCollection()
    func showSearch()
}


protocol AssetCollectionRouterActions: class {
    func showAlertOK(title: String, msg: String, presentingViewController: UIViewController)
    func showDetails(id: Int)
}

/// Simple AppRouter that controls navigation throughout the app
/// Encourages a greater seperation of concerns between ViewController (VC) and navigation.
/// This way we can focus ViewController on just the logic they need to perform their job
/// Also having this seperation allows us to easily manipulated the flow of the app for A/B testing with VCs needing to know

class AppRouter {

	private let window: UIWindow
	private let navigationController: UINavigationController
	private let viewControllerFactory: ViewControllerFactory
    private let informationAlert: InformationAlertProtocol


	init(window: UIWindow,
         navigationController: UINavigationController,
         viewControllerFactory: ViewControllerFactory,
         informationAlert: InformationAlertProtocol) {
		self.window = window
		self.viewControllerFactory = viewControllerFactory
		self.navigationController = navigationController
        self.informationAlert = informationAlert
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
	}


	func start() {
        let viewController = viewControllerFactory.makeHomeViewController(appActions: self)
        navigationController(navigationController, pushOnViewController: viewController, animated: false)
	}

    
    private func navigationController(_ navigationController: UINavigationController, pushOnViewController viewController:UIViewController, animated: Bool) {
        // Large scale application that push and pop whilst animating can suffer random failures when used alot in unit tests as the system can get confused,
        // by removing the animation we make the test simpler by not needing an expectation and more robust as timing is not involded which
        // causes the majority of flaky tests of these kind
        let isRunningTests = NSClassFromString("XCTestCase") != nil
        let shouldAnimate = isRunningTests ? false : animated
        navigationController.pushViewController(viewController, animated: shouldAnimate)
    }
}


extension AppRouter: HomeRouterActions {

    func showMoviesCollection() {
        let viewController = viewControllerFactory.makeMoviesViewController(appActions: self)
        navigationController(navigationController, pushOnViewController: viewController, animated: true)
    }

    func showSearch() {
        let viewController = viewControllerFactory.makeSearchViewController()
        navigationController(navigationController, pushOnViewController: viewController, animated: true)
    }
}


extension AppRouter: AssetCollectionRouterActions {

    func showAlertOK(title: String, msg: String, presentingViewController: UIViewController) {
        informationAlert.displayAlert(title: title, message: msg, presentingViewController: presentingViewController)
    }

    func showDetails(id: Int) {
        let viewController = viewControllerFactory.makeDetailsViewController()
        navigationController(navigationController, pushOnViewController: viewController, animated: true)
    }
}
