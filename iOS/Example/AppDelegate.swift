//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var appRouter: AppRouter?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return true }

        let thirdPartyAnalyticsReporter = AnalyticsReporterFacade()
        let analyticsFactory = AnalyticsReporterFactory(reporter: thirdPartyAnalyticsReporter)
        let viewControllerFactory = ViewControllerFactory(analyticsFactory: analyticsFactory)

        let navigationController = UINavigationController()

        appRouter = AppRouter(window: window,
                                   navigationController: navigationController,
                                   viewControllerFactory: viewControllerFactory,
                                   informationAlert: InformationAlert(),
                                   animateTransitions: true)
        
        appRouter?.start()

        return true
    }
}




// MARK:- App life cycle

extension AppDelegate {
	func applicationWillResignActive(_ application: UIApplication) {}
	func applicationDidEnterBackground(_ application: UIApplication) {}
	func applicationWillEnterForeground(_ application: UIApplication) {}
	func applicationDidBecomeActive(_ application: UIApplication) {}
	func applicationWillTerminate(_ application: UIApplication) {}
}

