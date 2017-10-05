//
//  AnalyticsReporterFactory.swift
//  Example
//
//  Created by Richard Moult on 5/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation

struct AnalyticsReporterFactory {

    // this should have access to 3rd party lib that can send info

    func makeMoviesReporter() -> MoviesReporter {
        return MoviesReporter()
    }
}
