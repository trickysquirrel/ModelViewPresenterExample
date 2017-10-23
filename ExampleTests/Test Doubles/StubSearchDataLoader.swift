//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation
@testable import Example


class StubSearchDataLoader: SearchDataLoading {

    var response: SearchDataLoaderResponse?
    private(set) var didRequestSearchString: [String] = []

    func load(searchString: String, completionQueue: DispatchQueue, completion:@escaping (SearchDataLoaderResponse)->()) {
        didRequestSearchString.append(searchString)
        if let response = self.response {
            completion(response)
        }
    }

}
