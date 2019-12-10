//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation


protocol AssetSearchPresenting {
    func updateSearchResults(searchString: String, running runner: AsyncRunner<AssetSearchPresenterResponse>)
}


enum AssetSearchPresenterResponse {
    case information(String)
    case clearSearchResults
    case success(String)
}


class AssetSearchPresenter: AssetSearchPresenting {

    let throttle: Throttling

    init(throttle: Throttling) {
        self.throttle = throttle
    }
}

// MARK:- Search feature

extension AssetSearchPresenter {

    func updateSearchResults(searchString: String, running runner: AsyncRunner<AssetSearchPresenterResponse>) {

        if let errorInfo = isSearchStringInvalid(string: searchString) {
            runner.run(.information(errorInfo))
            runner.run(.clearSearchResults)
            return
        }

        runner.run(.information(""))

        throttle.value(
            withDelay: 0.3,
            object: searchString,
            running: .on(.main) { throttledText in

            runner.run(.success(throttledText))
        })
    }
}

// MARK:- Utils

extension AssetSearchPresenter {

    private func isSearchStringInvalid(string: String) -> String? {
        guard (string.count > 0) else { return "" }
        guard (string.count >= 3) else { return "enter min 3 characters" }
        return nil
    }
}
