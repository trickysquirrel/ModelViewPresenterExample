//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var appCoordinator: AppRouter?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return true }

        let thirdPartyAnalyticsReporter = AnalyticsReporterFacade()
        let analyticsFactory = AnalyticsReporterFactory(reporter: thirdPartyAnalyticsReporter)
        let dataLoaderFactory = DataLoaderFactory()
        let getDataServiceFactory = GetDataServiceFactory(dataLoaderFactory: dataLoaderFactory)

        let viewControllerFactory = ViewControllerFactory(getDataServiceFactory: getDataServiceFactory,
                                                          analyticsFactory: analyticsFactory)

        let navigationController = UINavigationController()

        appCoordinator = AppRouter(window: window,
                                            navigationController: navigationController,
                                            viewControllerFactory: viewControllerFactory,
                                            informationAlert: InformationAlert())
        
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

