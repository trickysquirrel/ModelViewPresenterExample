//
//  AppActions.swift
//  Example
//
//  Created by Richard Moult on 4/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation

struct ShowMovieDetailsAction {

	let block: (()->())

	func perform() {
		block()
	}
}
