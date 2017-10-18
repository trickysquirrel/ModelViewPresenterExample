//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation
@testable import Example


class StubGetDataServiceFactory: GetDataServiceFactoryProtocol {

    func makeMoviesAssetCollectionDataLoader() -> AssetDataLoading {
        return StubAssetDataLoader()
    }
}
