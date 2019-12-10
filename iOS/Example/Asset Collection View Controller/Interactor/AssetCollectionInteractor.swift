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

    let assetDataLoader: AssetDataLoader2<AssetDataModel2>
    let backgroundQueue: DispatchQueue

    init(assetDataLoader: AssetDataLoader2<AssetDataModel2>, appDispatcher: AppDispatching) {
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



struct AssetDataLoader2<T> where T: Decodable {

    private let resource: String

    init(resource: String) {
        self.resource = resource
    }

    func load(running runner: AsyncRunner<Result<T, Error>>) {

        let generalError = NSError(domain: "Could not load data from resource file", code: 0, userInfo: nil)
        guard let location = Bundle.main.path(forResource: resource, ofType: "json") else {
            runner.run(.failure(generalError))
            return
        }

        let resourceUrl = URL(fileURLWithPath: location)

        guard
            let data = try? Data(contentsOf: resourceUrl),
            let dataModel = try? JSONDecoder().decode(T.self, from: data) else {
                runner.run(.failure(generalError))
                return
        }

        // adding in a delay before responding to simulate network delays
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            runner.run(.success(dataModel))
        }
    }
}
