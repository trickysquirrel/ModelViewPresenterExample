//
//  AppCoordinator.swift
//  Example
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
        let action = ShowMovieDetailsAction(block: { [weak self] in
            self?.showMovieDetailsViewController()
        })
		let viewController = viewControllerFactory.makeMoviesViewController(showMovieDetailAction: action)
		pushOnViewController(viewController)
	}

    
    private func showMovieDetailsViewController() {
        let viewController = viewControllerFactory.makeDetailsViewController()
        pushOnViewController(viewController)
    }
	
}


private extension AppCoordinator {
	func pushOnViewController(_ viewController:UIViewController) {
		navigationController.pushViewController(viewController, animated: true)
	}
}
