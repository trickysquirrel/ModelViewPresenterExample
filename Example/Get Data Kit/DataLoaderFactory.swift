//
//  Created by Richard Moult on 9/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation

protocol DataLoaderFactoryProtocol {
    func makeMovieAssetDataLoader() -> DataLoading
}

struct DataLoaderFactory: DataLoaderFactoryProtocol {

    func makeMovieAssetDataLoader() -> DataLoading {
        return DataLoader(resource: "movies")
    }
}
