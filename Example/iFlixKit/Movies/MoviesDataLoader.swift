//
//  MoviesDataLoader.swift
//  Example
//
//  Created by Richard Moult on 4/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation


struct MoviesDataLoader {

	let dataLoader: DataLoader

	func load() -> [MovieData]? {
		guard let moviesJson = dataLoader.load() else {
			// return error
			return nil
		}
		let moviesData = moviesJson.flatMap { makeMovie(json: $0) }
		return moviesData
	}
}

// MARK: Utils

extension MoviesDataLoader {

	private func makeMovie(json: [String:Any]) -> MovieData? {
		guard
			let endpoint = json["imageUrl"],
			let url = URL(string: "https:\(endpoint)")
        else {
				return nil
		}
/*
         "title": {
         "en_US": "Captain America: The First Avenger"
         },
 */
		return MovieData(title: "test title", imageUrl: url)
	}

}
