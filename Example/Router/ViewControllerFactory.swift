//
//  ViewControllerFactory.swift
//  Example
//
//  Created by Richard Moult on 4/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation
import UIKit


struct ViewControllerFactory {

    let iflixServiceFactory: IFlixServiceFactory
    let analyticsFactory: AnalyticsReporterFactory

    func makeMoviesViewController(showMovieDetailAction: AppMovieCollectionActions) -> UIViewController {
        let moviesDataLoader = iflixServiceFactory.makeMoviesAssetCollectionDataLoader()
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
            appActions: showMovieDetailAction)
    }

    func makeDetailsViewController() -> UIViewController {
		let viewController = AssetDetailsViewController()
        return viewController
	}

}
