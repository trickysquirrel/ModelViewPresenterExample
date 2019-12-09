//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example


class StubAssetCollectionPresenter: AssetCollectionPresenting {

    var runner: AsyncRunner<AssetCollectionPresenterResponse>?

    func updateView(running runner: AsyncRunner<AssetCollectionPresenterResponse>) {
        self.runner = runner
    }
}
