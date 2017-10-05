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
		let moviesDataLoader = MoviesDataLoader(dataLoader: dataLoader)
		let presenter = MovieCollectionPresenter(moviesDataLoader: moviesDataLoader)
		let dataSource = CollectionViewDataSource<MoviesCollectionViewCell, MovieViewModel>()
        return MoviesCollectionViewController(presenter: presenter,
		                                      dataSource: dataSource,
                                              reporter: analyticsFactory.makeMoviesReporter(),
                                              loadingIndicator: LoadingIndicator(),
                                              alert: InformationAlert(),
		                                      appActions: showMovieDetailAction)
	}

	func makeDetailsViewController() -> UIViewController {
		return UIViewController()
	}

}
