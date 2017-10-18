//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation

protocol GetDataServiceFactoryProtocol {
    func makeMoviesAssetCollectionDataLoader() -> AssetDataLoading
}

struct GetDataServiceFactory: GetDataServiceFactoryProtocol {

    let dataLoaderFactory: DataLoaderFactoryProtocol

    func makeMoviesAssetCollectionDataLoader() -> AssetDataLoading {
        let dataLoader = dataLoaderFactory.makeMovieAssetDataLoader()
        let moviesDataLoader = AssetDataLoader(dataLoader: dataLoader)
        return moviesDataLoader
    }

}
