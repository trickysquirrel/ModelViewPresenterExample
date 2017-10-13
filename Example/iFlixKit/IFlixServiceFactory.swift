//
//  iFlixServiceFactory.swift
//  Example
//
//  Created by Richard Moult on 8/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation

protocol IFlixServiceFactoryProtocol {
    func makeMoviesAssetCollectionDataLoader() -> AssetDataLoading
}

struct IFlixServiceFactory: IFlixServiceFactoryProtocol {

    let dataLoaderFactory: DataLoaderFactoryProtocol

    func makeMoviesAssetCollectionDataLoader() -> AssetDataLoading {
        let dataLoader = dataLoaderFactory.makeMovieAssetDataLoader()
        let moviesDataLoader = AssetDataLoader(dataLoader: dataLoader)
        return moviesDataLoader
    }

}
