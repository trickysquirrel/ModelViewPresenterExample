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

    let analyticsFactory: AnalyticsReporterFactory

    func makeMoviesViewController(showMovieDetailAction: AppMovieCollectionActions) -> UIViewController {
        let dataLoader = DataLoader(resource: "movies")
        let moviesDataLoader = AssetDataLoader(dataLoader: dataLoader)
        let presenter = AssetCollectionPresenter(assetDataLoader: moviesDataLoader)
        let dataSource = CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>()
        let configureCollectionView = ConfigureCollectionView()
        return AssetCollectionViewController(
            presenter: presenter,
            configureCollectionView: configureCollectionView,
            dataSource: dataSource,
            reporter: analyticsFactory.makeAssetCollectionReporter(),
            loadingIndicator: LoadingIndicator(),
            alert: InformationAlert(),
            appActions: showMovieDetailAction)
    }

    func makeDetailsViewController() -> UIViewController {
		return UIViewController()
	}

}
