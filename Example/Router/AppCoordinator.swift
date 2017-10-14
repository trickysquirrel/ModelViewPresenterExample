//
//  Created by Richard Moult on 4/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit


class AppCoordinator {

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


	func showRootViewController() {
        let action = AppMovieCollectionActions(alert: InformationAlert(), block: { [weak self] id in
            self?.showMovieDetailsViewController()
        })
		let viewController = viewControllerFactory.makeMoviesViewController(showMovieDetailAction: action)
		pushOnViewController(viewController, animated: false)
	}

    
    private func showMovieDetailsViewController() {
        let viewController = viewControllerFactory.makeDetailsViewController()
        pushOnViewController(viewController, animated: true)
    }
	
}


private extension AppCoordinator {
    func pushOnViewController(_ viewController:UIViewController, animated: Bool) {
        let isRunningTests = NSClassFromString("XCTestCase") != nil
        let shouldAnimate = isRunningTests ? false : animated
		navigationController.pushViewController(viewController, animated: shouldAnimate)
	}
}
