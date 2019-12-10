//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation
import UIKit

/// A common place to make all ViewController
/// By having all VCs generated in one place we can bring together all the common components required to build the VCs
/// A lot of those components can then be hidden from the AppRouter and only those properties that specialise need be injected

struct ViewControllerFactory {

    let analyticsFactory: AnalyticsReporterFactory

    func makeHomeViewController(appActions: HomeRouterActions) -> UIViewController {
        let viewController = HomeViewController(appActions: appActions)
        return viewController
    }

    func makeMoviesViewController(appActions: AssetCollectionRouterActions) -> UIViewController {
        let appDispatcher = AppDispatcher()
        let moviesDataLoader = AssetDataLoader<AssetDataModel2>(resource: "movies")
        let interactor = AssetCollectionInterator(assetDataLoader: moviesDataLoader, appDispatcher: appDispatcher)
        let presenter = AssetCollectionPresenter(interactor: interactor, appDispatcher: appDispatcher)
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

    func makeSearchResultsViewController(appActions: AssetCollectionRouterActions, searchText: String) -> UIViewController {
        let search = "search" // should use searchText but for this example hardcoded
        let appDispatcher = AppDispatcher()
        let moviesDataLoader = AssetDataLoader<AssetDataModel2>(resource: search)
        let interactor = AssetCollectionInterator(assetDataLoader: moviesDataLoader, appDispatcher: appDispatcher)
        let presenter = AssetCollectionPresenter(interactor: interactor, appDispatcher: appDispatcher)
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

    func makeDetailsViewController(title: String) -> UIViewController {
        let viewController = AssetDetailsViewController(title: title)
        return viewController
	}

    func makeSearchViewController(appActions: SearchRouterActions) -> UIViewController {
        let throttle = Throttle()
        let presenter = AssetSearchPresenter(throttle: throttle)
        let searchController = UISearchController(searchResultsController: nil)
        let viewController = AssetSearchViewController(
            searchController: searchController,
            presenter: presenter,
            reporter: analyticsFactory.makeSearchReporter(),
            appActions: appActions)
        return viewController
    }
}
