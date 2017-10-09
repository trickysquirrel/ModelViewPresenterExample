//
//  StubIFlixServiceFactory.swift
//  ExampleTests
//
//  Created by Richard Moult on 9/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation
@testable import Example


class StubDataLoader: DataLoading {

    var responseDictionary: [[String:Any]]?

    func load() -> [[String: Any]]? {
        return responseDictionary
    }
}


struct StubDataLoaderFactory: DataLoaderFactoryProtocol {

    let stubDataLoader: StubDataLoader

    init(stubDataLoader: StubDataLoader) {
        self.stubDataLoader = stubDataLoader
    }

    func makeMovieAssetDataLoader() -> DataLoading {
        return stubDataLoader
    }
}

