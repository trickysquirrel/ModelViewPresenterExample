//
//  Copyright © 2019 Richard Moult. All rights reserved.
//

import Foundation

struct AssetDataModel2: Decodable {
    let data: DataModel

    struct DataModel: Decodable {
        let items: [AssetItem]
    }
}

struct AssetItem: Decodable {
    let id: String
    let title: String
    let image: Image

    struct Image: Decodable {
        let url: URL
    }
}

typealias AssetCollectionInteractorResponse = Result<[AssetItem], Error>

protocol AssetCollectionInteracting {
    func load(running runner: AsyncRunner<AssetCollectionInteractorResponse>)
}

class AssetCollectionInterator: AssetCollectionInteracting {

    let assetDataLoader: AssetDataLoader<AssetDataModel2>
    let backgroundQueue: DispatchQueue

    init(assetDataLoader: AssetDataLoader<AssetDataModel2>, appDispatcher: AppDispatching) {
        self.assetDataLoader = assetDataLoader
        backgroundQueue = appDispatcher.makeBackgroundQueue()
    }

    func load(running runner: AsyncRunner<AssetCollectionInteractorResponse>) {
        assetDataLoader.load(running: .on(backgroundQueue) { (result) in
            switch result {
            case .success(let dataModel):
                runner.run(.success(dataModel.data.items))
            case .failure(let error):
                runner.run(.failure(error))
            }
        })
    }
}
