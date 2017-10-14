//
//  Created by Richard Moult on 9/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation
@testable import Example


class StubAssetDataLoader: AssetDataLoading {

    var stubResponse: AssetDataLoaderResponse?

    func load(completionQueue: DispatchQueue, completion:@escaping (AssetDataLoaderResponse)->()) {
        if let response = stubResponse {
            completion(response)
        }
    }
}
