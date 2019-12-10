//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation


struct SearchDataModel {
    let id: Int
    let title: String
    let imageUrl: URL
}


enum SearchDataLoaderResponse {
    case success([SearchDataModel])
    case error(Error)
}


protocol SearchDataLoading {
    func load(searchString: String, running runner: AsyncRunner<SearchDataLoaderResponse>)
}


struct SearchDataLoader: SearchDataLoading {

    let dataLoader: DataLoading

    func load(searchString: String, running runner: AsyncRunner<SearchDataLoaderResponse>) {
        guard let assetJson = dataLoader.load() else {
            let tempError = NSError(domain: "Could not load data from resource file", code: 0, userInfo: nil)
            runner.run(.error(tempError))
            return
        }
        let assetDataModelList = assetJson.compactMap { makeSearchData(json: $0) }

        // adding in a delay before responding
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            runner.run(.success(assetDataModelList))
        }
    }
}

// MARK: Utils

extension SearchDataLoader {

    private func makeSearchData(json: [String:Any]) -> SearchDataModel? {
        guard
            let id = json["id"] as? Int,
            let endpoint = json["imageUrl"],
            let url = URL(string: "https:\(endpoint)"),
            let title = json["title"] as? [String:Any],
            let usTitle = title["en_US"] as? String
            else {
                return nil
        }

        return SearchDataModel(id: id, title: usTitle, imageUrl: url)
    }

}
