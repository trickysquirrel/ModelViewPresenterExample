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
    func load(searchString: String, completionQueue: DispatchQueue, completion:@escaping (SearchDataLoaderResponse)->())
    func cancel()
}


struct SearchDataLoader: SearchDataLoading {

    func load(searchString: String, completionQueue: DispatchQueue, completion:@escaping (SearchDataLoaderResponse)->()) {
    }

    func cancel() {
        
    }
}
