//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation

protocol DataLoaderFactoryProtocol {
    func makeMovieAssetDataLoader() -> DataLoading
    func makeSearchDataLoader() -> DataLoading
}

struct DataLoaderFactory: DataLoaderFactoryProtocol {

    func makeMovieAssetDataLoader() -> DataLoading {
        return DataLoader(resource: "movies")
    }

    func makeSearchDataLoader() -> DataLoading {
        return DataLoader(resource: "search")
    }
}
