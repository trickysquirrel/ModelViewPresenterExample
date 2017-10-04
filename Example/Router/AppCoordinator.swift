//
//  AppCoordinator.swift
//  Example
//
//  Created by Richard Moult on 4/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit


struct AppCoordinator {

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
		let viewController = viewControllerFactory.makeMoviesViewController()
		pushOnViewController(viewController)
	}
	
}


private extension AppCoordinator {
	func pushOnViewController(_ viewController:UIViewController) {
		navigationController.pushViewController(viewController, animated: true)
	}
}
