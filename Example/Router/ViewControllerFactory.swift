//
//  ViewControllerFactory.swift
//  Example
//
//  Created by Richard Moult on 4/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation


struct ViewControllerFactory {

	func makeMoviesViewController() -> MoviesCollectionViewController {
		let dataLoader = DataLoader(resource: "movies")
		let moviesDataLoader = MoviesDataLoader(dataLoader: dataLoader)
		let presenter = MoviesPresenter(moviesDataLoader: moviesDataLoader)
		return MoviesCollectionViewController(presenter: presenter)
	}

}
