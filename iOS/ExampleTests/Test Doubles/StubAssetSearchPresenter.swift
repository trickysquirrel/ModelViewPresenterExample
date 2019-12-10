//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation
import XCTest
@testable import Example


class StubAssetSearchPresenter: AssetSearchPresenting {

    private(set) var didCallUpdateSearchResultsWithString: String?
    var runner: AsyncRunner<AssetSearchPresenterResponse>?

    func updateSearchResults(searchString: String, running runner: AsyncRunner<AssetSearchPresenterResponse>) {
        didCallUpdateSearchResultsWithString = searchString
        self.runner = runner
    }
}
