//
//  MoviesPresenter.swift
//  Example
//
//  Created by Richard Moult on 4/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation


struct MoviesViewModel {
	let imageUrl: URL
}

enum MoviesPresenterResponse {
	case loading(Bool)
	case success([MoviesViewModel])
	case noResults
	case error(msg:String)
}


struct MoviesPresenter {

	let moviesDataLoader: MoviesDataLoader


	func updateView(completion:(MoviesPresenterResponse)->()) {

		if let moviesData = moviesDataLoader.load() {
			let viewModels = moviesData.map { MoviesViewModel(imageUrl: $0.imageUrl) }
			if viewModels.count == 0 {
				completion(.noResults)
			}
			else {
				completion(.success(viewModels))
			}
		}
		else {
			completion(.error(msg: "this is an error message"))
		}
	}

}
