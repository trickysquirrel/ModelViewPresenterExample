//
//  StubIFlixServiceFactory.swift
//  ExampleTests
//
//  Created by Richard Moult on 9/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation
@testable import Example


class StubAssetDataLoader: AssetDataLoading {

    var stubResponse: AssetDataLoaderResponse?

    func load(completionQueue: DispatchQueue, completion:@escaping (AssetDataLoaderResponse)->()) {
        if let response = stubResponse {
            completion(response)
        }
    }
}



class StubIFlixServiceFactory: IFlixServiceFactoryProtocol {

    func makeMoviesAssetCollectionDataLoader() -> AssetDataLoading {
        return StubAssetDataLoader()
    }
}


// todo check we are using these


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

