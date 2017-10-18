//
//  Created by Richard Moult on 4/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation
import UIKit


struct ViewControllerFactory {

    let getDataServiceFactory: GetDataServiceFactoryProtocol
    let analyticsFactory: AnalyticsReporterFactory

    func makeAssetTypeSelectionViewController(appActions: AssetTypeSelectionCoordinatorActions) -> UIViewController {
        let viewController = AssetTypeSelectionViewController(appActions: appActions)
        return viewController
    }

    func makeMoviesViewController(appActions: AssetCollectionCoordinatorActions) -> UIViewController {
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
        let presenter = AssetSearchPresenter()
        let searchController = UISearchController(searchResultsController: nil)
        let configureCollectionView = ConfigureCollectionView()
        let dataSource = CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>()
        let viewController = AssetSearchViewController(searchController: searchController,
                                                       presenter: presenter,
                                                       loadingIndicator: LoadingIndicator(),
                                                       configureCollectionView: configureCollectionView,
                                                       dataSource: dataSource)
        return viewController
    }
}
