//
//  MoviesDataLoader.swift
//  Example
//
//  Created by Richard Moult on 4/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation


enum AssetDataLoaderResponse {
    case success([AssetDataModel])
    case error(Error)
}


struct AssetDataLoader {

	let dataLoader: DataLoader

    func load(completionQueue: DispatchQueue, completion:@escaping (AssetDataLoaderResponse)->()) {
		guard let assetJson = dataLoader.load() else {
            completionQueue.async {
                let tempError = NSError(domain: "", code: 0, userInfo: nil)
                completion(.error(tempError))
            }
            return
		}
        let assetDataModelList = assetJson.flatMap { makeAssetData(json: $0) }

        // adding in a delay before responding
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            completionQueue.async {
                completion(.success(assetDataModelList))
            }
        }

	}
}

// MARK: Utils

extension AssetDataLoader {

	private func makeAssetData(json: [String:Any]) -> AssetDataModel? {
		guard
			let endpoint = json["imageUrl"],
			let url = URL(string: "https:\(endpoint)"),
            let title = json["title"] as? [String:Any],
            let usTitle = title["en_US"] as? String
        else {
				return nil
		}

        return AssetDataModel(title: usTitle, imageUrl: url)
	}

}
