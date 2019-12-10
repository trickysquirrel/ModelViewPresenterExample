//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation


enum AssetDataLoaderResponse {
    case success([AssetDataModel])
    case error(Error)
}

protocol AssetDataLoading {
    func load(running runner: AsyncRunner<AssetDataLoaderResponse>)
}

struct AssetDataLoader: AssetDataLoading {

	let dataLoader: DataLoading

    func load(running runner: AsyncRunner<AssetDataLoaderResponse>) {
		guard let assetJson = dataLoader.load() else {
            let tempError = NSError(domain: "Could not load data from resource file", code: 0, userInfo: nil)
            runner.run(.error(tempError))
            return
		}
        let assetDataModelList = assetJson.compactMap { makeAssetData(json: $0) }

        // adding in a delay before responding to simulate network delays
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            runner.run(.success(assetDataModelList))
        }
	}
}

// MARK: Utils

extension AssetDataLoader {

	private func makeAssetData(json: [String:Any]) -> AssetDataModel? {
		guard
            let id = json["id"] as? Int,
			let endpoint = json["imageUrl"],
			let url = URL(string: "https:\(endpoint)"),
            let title = json["title"] as? [String:Any],
            let usTitle = title["en_US"] as? String
        else {
				return nil
		}

        return AssetDataModel(id: id, title: usTitle, imageUrl: url)
	}

}
