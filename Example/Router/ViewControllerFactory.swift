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

	func makeMoviesViewController(showMovieDetailAction: ShowMovieDetailsAction) -> UIViewController {
		let dataLoader = DataLoader(resource: "movies")
		let moviesDataLoader = MoviesDataLoader(dataLoader: dataLoader)
		let presenter = MoviesPresenter(moviesDataLoader: moviesDataLoader)
		let dataSource = CollectionViewDataSource<MoviesCollectionViewCell, MoviesViewModel>()
        return MoviesCollectionViewController(presenter: presenter,
		                                      dataSource: dataSource,
                                              reporter: analyticsFactory.makeMoviesReporter(),
                                              loadingIndicator: LoadingIndicator(),
                                              alert: InformationAlert(),
		                                      showMovieDetailAction: showMovieDetailAction)
	}

	func makeDetailsViewController() -> UIViewController {
		return UIViewController()
	}

}
