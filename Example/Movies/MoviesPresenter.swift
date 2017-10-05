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
    case loading(show: Bool)
	case success([MoviesViewModel])
    case noResults(title: String, msg:String)
    case error(title: String, msg:String)
}


struct MoviesPresenter {

	let moviesDataLoader: MoviesDataLoader


	func updateView(completion:(MoviesPresenterResponse)->()) {

        completion(.loading(show: true))

		if let moviesData = moviesDataLoader.load() {
			let viewModels = moviesData.map { MoviesViewModel(imageUrl: $0.imageUrl) }
			if viewModels.count == 0 {
                completion(.noResults(title:"title", msg:"no results try again later"))
			}
			else {
				completion(.success(viewModels))
			}
		}
		else {
            completion(.error(title: "error", msg: "this is an error message"))
		}

        completion(.loading(show: false))
	}

}
