//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation


protocol AssetSearchPresenting {
    typealias updateHandlerType = (AssetSearchPresenterResponse)->()
    func navigationTitle() -> String
    func searchBarPlaceHolderText() -> String
    func updateSearchResults(searchString: String, updateHandler: @escaping updateHandlerType)
}


enum AssetSearchPresenterResponse {
    case loading(show: Bool)
    case information(String)
    case success([AssetViewModel])
}


class AssetSearchPresenter: AssetSearchPresenting {

    let throttle: Throttling
    let searchDataLoader: SearchDataLoading
    let appDispatcher: AppDispatching
    let backgroundQueue: DispatchQueue


    init(throttle: Throttling, searchDataLoader: SearchDataLoading, appDispatcher: AppDispatching) {
        self.throttle = throttle
        self.searchDataLoader = searchDataLoader
        self.appDispatcher = appDispatcher
        self.backgroundQueue = appDispatcher.makeBackgroundQueue()
    }


    func navigationTitle() -> String {
        return "Search"
    }


    func searchBarPlaceHolderText() -> String {
        return "enter title"
    }
}

// MARK:- Search feature

extension AssetSearchPresenter {

    func updateSearchResults(searchString: String, updateHandler: @escaping updateHandlerType) {

        searchDataLoader.cancel()

        if let errorInfo = isSearchStringInvalid(string: searchString) {
            notPerformingSearchUpdateHandler(information: errorInfo, updateHandler: updateHandler)
            return
        }
        
        updateHandler(.information(""))

        throttle.value(withDelay: 0.3, object: searchString) { [weak self] throttledText in

            guard let strongSelf = self else { return }

            updateHandler(.loading(show: true))
            updateHandler(.success([]))

            strongSelf.searchDataLoader.load(searchString: searchString, completionQueue: strongSelf.backgroundQueue) { [weak self] response in

                guard let strongSelf = self else { return }

                switch response {
                case .error:
                    strongSelf.onMainThreadupdateHandlerResponseWithError(updateHandler: updateHandler)
                case .success(let searchDataList):
                    strongSelf.onMainThreadUpdateHandlerResponse(searchDataList: searchDataList, updateHandler: updateHandler)
                }
            }
        }
    }
}

// MARK:- Utils

extension AssetSearchPresenter {

    private func isSearchStringInvalid(string: String) -> String? {
        guard (string.count > 0) else { return "" }
        guard (string.count >= 3) else { return "enter min 3 characters" }
        return nil
    }


    private func notPerformingSearchUpdateHandler(information: String, updateHandler: @escaping updateHandlerType) {
        updateHandler(.information(information))
        updateHandler(.success([]))
    }


    private func onMainThreadupdateHandlerResponseWithError(updateHandler: @escaping updateHandlerType) {
        appDispatcher.runMainAsync {
            updateHandler(.loading(show: false))
            updateHandler(.information("there was an error please try again"))
        }
    }


    private func onMainThreadUpdateHandlerResponse(searchDataList: [SearchDataModel], updateHandler: @escaping updateHandlerType) {
        var response: AssetSearchPresenterResponse
        if searchDataList.count == 0 {
            response = .information("no results please try again")
        }
        else {
            let viewModelList = searchDataList.map { AssetViewModel(id: $0.id, title: $0.title, imageUrl: $0.imageUrl) }
            response = .success(viewModelList)
        }

        appDispatcher.runMainAsync {
            updateHandler(.loading(show: false))
            updateHandler(response)
        }
    }
}
