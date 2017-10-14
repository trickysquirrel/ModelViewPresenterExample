//
//  AppDelegate.swift
//  Example
//
//  Created by Richard Moult on 4/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var appCoordinator: RootAppCoordinator?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return true }

        let thirdPartyAnalyticsReporter = ThirdyPartyAnalyticsReporter()
        let analyticsFactory = AnalyticsReporterFactory(thirdPartyAnalyticsReporter: thirdPartyAnalyticsReporter)
        let dataLoaderFactory = DataLoaderFactory()
        let getDataServiceFactory = GetDataServiceFactory(dataLoaderFactory: dataLoaderFactory)

        let viewControllerFactory = ViewControllerFactory(getDataServiceFactory: getDataServiceFactory,
                                                          analyticsFactory: analyticsFactory)

        let navigationController = UINavigationController()

        appCoordinator = RootAppCoordinator(window: window, navigationController: navigationController, viewControllerFactory: viewControllerFactory)
        
        appCoordinator?.start()

        return true
	}
}




// MARK:- App life cycle

extension AppDelegate {
	func applicationWillResignActive(_ application: UIApplication) {
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
	}

	func applicationWillTerminate(_ application: UIApplication) {
	}
}

