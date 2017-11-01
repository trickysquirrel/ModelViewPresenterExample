//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation
import XCTest
@testable import Example


class StubAssetSearchPresenter: AssetSearchPresenting {

    private(set) var didCallUpdateSearchResultsWithString: String?
    var updateHandler: updateHandlerType?

    func navigationTitle() -> String {
        return "search test title"
    }

    func searchBarPlaceHolderText() -> String {
        return "not tested yet as could not figure out how to get search bar to initialise"
    }

    func updateSearchResults(searchString: String, updateHandler: @escaping updateHandlerType) {
        didCallUpdateSearchResultsWithString = searchString
        self.updateHandler = updateHandler
    }
}
