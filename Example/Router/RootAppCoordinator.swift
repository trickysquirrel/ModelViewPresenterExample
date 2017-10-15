//
//  Created by Richard Moult on 4/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit

protocol AssetTypeSelectionCoordinatorActions: class {
    func showMoviesCollection()
}


protocol AssetCollectionCoordinatorActions: class {
    func showAlertOK(title: String, msg: String, presentingViewController: UIViewController)
    func showDetails(id: Int)
}


class RootAppCoordinator {

	private let window: UIWindow
	private let navigationController: UINavigationController
	private let viewControllerFactory: ViewControllerFactory


	init(window: UIWindow, navigationController: UINavigationController, viewControllerFactory: ViewControllerFactory) {
		self.window = window
		self.viewControllerFactory = viewControllerFactory
		self.navigationController = navigationController
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
	}


	func start() {
        let viewController = viewControllerFactory.makeAssetTypeSelectionViewController(appActions: self)
        navigationController(navigationController, pushOnViewController: viewController, animated: false)
	}

    
    private func navigationController(_ navigationController: UINavigationController, pushOnViewController viewController:UIViewController, animated: Bool) {
        let isRunningTests = NSClassFromString("XCTestCase") != nil
        let shouldAnimate = isRunningTests ? false : animated
        navigationController.pushViewController(viewController, animated: shouldAnimate)
    }
}


extension RootAppCoordinator: AssetTypeSelectionCoordinatorActions {

    func showMoviesCollection() {
        let viewController = viewControllerFactory.makeMoviesViewController(appActions: self)
        navigationController(navigationController, pushOnViewController: viewController, animated: true)
    }
}


extension RootAppCoordinator: AssetCollectionCoordinatorActions {

    func showAlertOK(title: String, msg: String, presentingViewController: UIViewController) {
        InformationAlert().displayAlert(title: title, message: msg, presentingViewController: presentingViewController)
    }

    func showDetails(id: Int) {
        let viewController = viewControllerFactory.makeDetailsViewController()
        navigationController(navigationController, pushOnViewController: viewController, animated: true)
    }
}
