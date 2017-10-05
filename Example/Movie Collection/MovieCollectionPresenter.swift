//
//  MoviesPresenter.swift
//  Example
//
//  Created by Richard Moult on 4/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation


struct MovieViewModel {
	let imageUrl: URL
}

enum MovieCollectionPresenterResponse {
    case loading(show: Bool)
	case success([MovieViewModel])
    case noResults(title: String, msg:String)
    case error(title: String, msg:String)
}


struct MovieCollectionPresenter {

	let moviesDataLoader: MoviesDataLoader


	func updateView(completion:(MovieCollectionPresenterResponse)->()) {

        completion(.loading(show: true))

		if let moviesData = moviesDataLoader.load() {
			let viewModels = moviesData.map { MovieViewModel(imageUrl: $0.imageUrl) }
			if viewModels.count > 0 {
                completion(.success(viewModels))
			}
			else {
                completion(.noResults(title:"title", msg:"no results try again later"))
			}
		}
		else {
            completion(.error(title: "error", msg: "this is an error message"))
		}

        completion(.loading(show: false))
	}

}
