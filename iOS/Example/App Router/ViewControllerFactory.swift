//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation
import UIKit

/// A common place to make all ViewController
/// By having all VCs generated in one place we can bring together all the common components required to build the VCs
/// A lot of those components can then be hidden from the AppRouter and only those properties that specialise need be injected

struct ViewControllerFactory {

    let getDataServiceFactory: GetDataServiceFactoryProtocol
    let analyticsFactory: AnalyticsReporterFactory

    func makeHomeViewController(appActions: HomeRouterActions) -> UIViewController {
        let viewController = HomeViewController(appActions: appActions)
        return viewController
    }

    func makeMoviesViewController(appActions: AssetCollectionRouterActions) -> UIViewController {
        let moviesDataLoader = getDataServiceFactory.makeMoviesAssetCollectionDataLoader()
        let presenter = AssetCollectionPresenter(assetDataLoader: moviesDataLoader, appDispatcher: AppDispatcher())
        let dataSource = CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>()
        let configureCollectionView = ConfigureCollectionView()
        return AssetCollectionViewController(
            title: "Movies",
            presenter: presenter,
            configureCollectionView: configureCollectionView,
            dataSource: dataSource,
            reporter: analyticsFactory.makeAssetCollectionReporter(),
            loadingIndicator: LoadingIndicator(),
            appActions: appActions)
    }

    func makeDetailsViewController() -> UIViewController {
		let viewController = AssetDetailsViewController()
        return viewController
	}

    func makeSearchViewController() -> UIViewController {
        let throttle = Throttle()
        let searchDataLoader = getDataServiceFactory.makeSearchDataLoader()
        let presenter = AssetSearchPresenter(throttle: throttle, searchDataLoader: searchDataLoader, appDispatcher: AppDispatcher())
        let searchController = UISearchController(searchResultsController: nil)
        let configureCollectionView = ConfigureCollectionView()
        let dataSource = CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>()
        let viewController = AssetSearchViewController(
            searchController: searchController,
            presenter: presenter,
            loadingIndicator: LoadingIndicator(),
            configureCollectionView: configureCollectionView,
            dataSource: dataSource,
            reporter: analyticsFactory.makeSearchReporter())
        return viewController
    }
}
