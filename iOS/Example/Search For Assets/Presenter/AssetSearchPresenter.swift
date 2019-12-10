//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation


protocol AssetSearchPresenting {
    func updateSearchResults(searchString: String, running runner: AsyncRunner<AssetSearchPresenterResponse>)
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
}

// MARK:- Search feature

extension AssetSearchPresenter {

    func updateSearchResults(searchString: String, running runner: AsyncRunner<AssetSearchPresenterResponse>) {

        if let errorInfo = isSearchStringInvalid(string: searchString) {
            handleInvalidSearchTerm(information: errorInfo, running: runner)
            return
        }

        runner.run(.information(""))

        throttle.value(withDelay: 0.3, object: searchString) { [weak self] throttledText in

            guard let self = self else { return }

            runner.run(.loading(show: true))
            runner.run(.success([]))

            self.searchDataLoader.load(
                searchString: searchString,
                running: .on(self.backgroundQueue) { [weak self] response in

                guard let self = self else { return }

                switch response {
                case .error:
                    self.handleError(running: runner)
                case .success(let searchDataList):
                    self.handleResponse(searchDataList: searchDataList, running: runner)
                }
            })
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


    private func handleInvalidSearchTerm(information: String, running runner: AsyncRunner<AssetSearchPresenterResponse>) {
        runner.run(.information(information))
        runner.run(.success([]))
    }


    private func handleError(running runner: AsyncRunner<AssetSearchPresenterResponse>) {
        runner.run(.loading(show: false))
        runner.run(.information("there was an error please try again"))
    }


    private func handleResponse(searchDataList: [SearchDataModel], running runner: AsyncRunner<AssetSearchPresenterResponse>) {
        var response: AssetSearchPresenterResponse
        if searchDataList.count == 0 {
            response = .information("no results please try again")
        }
        else {
            let viewModelList = searchDataList.map { AssetViewModel(id: $0.id, title: $0.title, imageUrl: $0.imageUrl) }
            response = .success(viewModelList)
        }
        runner.run(.loading(show: false))
        runner.run(response)
    }
}
