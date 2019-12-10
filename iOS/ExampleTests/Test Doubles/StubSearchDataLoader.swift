//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation
@testable import Example


class StubSearchDataLoader: SearchDataLoading {

    var response: SearchDataLoaderResponse?
    private(set) var didRequestSearchString: [String] = []

    func load(searchString: String, running runner: AsyncRunner<SearchDataLoaderResponse>) {
        didRequestSearchString.append(searchString)
        if let response = self.response {
            runner.run(response)
        }
    }
}
