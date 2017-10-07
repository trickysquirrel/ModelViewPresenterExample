//
//  iFlixServiceFactory.swift
//  Example
//
//  Created by Richard Moult on 8/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation


protocol IFlixServiceFactoryProtocol {
    func makeMoviesAssetCollectionDataLoader() -> AssetDataLoader
}


struct IFlixServiceFactory: IFlixServiceFactoryProtocol {

    func makeMoviesAssetCollectionDataLoader() -> AssetDataLoader {
        let dataLoader = DataLoader(resource: "movies")
        let moviesDataLoader = AssetDataLoader(dataLoader: dataLoader)
        return moviesDataLoader
    }

}
