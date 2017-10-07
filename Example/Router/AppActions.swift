//
//  AppActions.swift
//  Example
//
//  Created by Richard Moult on 4/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation

struct AppMovieCollectionActions {

    // pre load with extra info so view controller does not need to know about it
	let block: (()->())

	func performShowDetails() {
        // this could generate urls with are passed back rather than calling specific methods
		block()
	}
}
