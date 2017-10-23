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


    init(throttle: Throttling, searchDataLoader: SearchDataLoading, appDispatcher: AppDispatching) {
        self.throttle = throttle
        self.searchDataLoader = searchDataLoader
        self.appDispatcher = appDispatcher
    }


    func navigationTitle() -> String {
        return "Search"
    }


    func searchBarPlaceHolderText() -> String {
        return "enter title"
    }


    func updateSearchResults(searchString: String, updateHandler: @escaping updateHandlerType) {

        guard (searchString.count >= 3) else {
            updateHandler(.information("enter min 3 characters"))
            return
        }

        let backgroundQueue = appDispatcher.makeBackgroundQueue()
        
        updateHandler(.information(""))

        throttle.value(withDelay: 0.3, object: searchString) { [weak self] throttledText in
            updateHandler(.loading(show: true))

            self?.searchDataLoader.load(searchString: searchString, completionQueue: backgroundQueue) { [weak self] response in

                guard let strongSelf = self else { return }
                var presenterResponse: AssetSearchPresenterResponse

                switch response {
                case .error:
                    presenterResponse = .information("there was an error please try again")
                case .success(let searchDataList):
                    presenterResponse = strongSelf.responseForSearchDataList(searchDataList: searchDataList)
                }

                strongSelf.finalMainThreadUpdateHandlerResponse(response: presenterResponse, updateHandler: updateHandler)
            }
        }
    }


    private func responseForSearchDataList(searchDataList: [SearchDataModel]) -> AssetSearchPresenterResponse {
        if searchDataList.count == 0 {
            return .information("no results please try again")
        }
        else {
            let viewModelList = searchDataList.map { AssetViewModel(id: $0.id, title: $0.title, imageUrl: $0.imageUrl) }
            return .success(viewModelList)
        }
    }


    private func finalMainThreadUpdateHandlerResponse(response: AssetSearchPresenterResponse, updateHandler: @escaping updateHandlerType) {
        appDispatcher.runMainAsync {
            updateHandler(.loading(show: false))
            updateHandler(response)
        }
    }
}
