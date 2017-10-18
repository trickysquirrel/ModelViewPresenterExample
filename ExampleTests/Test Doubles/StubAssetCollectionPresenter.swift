//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example


class StubAssetCollectionPresenter: AssetCollectionPresenting {

    var updateHandler: CompletionAlias?

    func updateView(updateHandler: @escaping CompletionAlias) {
        self.updateHandler = updateHandler
    }
}

