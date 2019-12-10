//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation
@testable import Example


class StubAssetDataLoader: AssetDataLoading {

    var stubResponse: AssetDataLoaderResponse?

    func load(running runner: AsyncRunner<AssetDataLoaderResponse>) {
        if let response = stubResponse {
            runner.run(response)
        }
    }
}
