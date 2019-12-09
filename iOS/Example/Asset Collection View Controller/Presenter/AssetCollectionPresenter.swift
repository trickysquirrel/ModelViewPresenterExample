//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation


struct AssetViewModel {
    let id: Int
    let title: String
	let imageUrl: URL
}


enum AssetCollectionPresenterResponse {
    case loading(show: Bool)
	case success([AssetViewModel])
    case noResults(title: String, msg:String)
    case error(title: String, msg:String)
}


protocol AssetCollectionPresenting {
    func updateView(running runner: AsyncRunner<AssetCollectionPresenterResponse>)
}


class AssetCollectionPresenter: AssetCollectionPresenting {

	let assetDataLoader: AssetDataLoading
    let appDispatcher: AppDispatching
    let backgroundQueue: DispatchQueue

    
    init(assetDataLoader: AssetDataLoading, appDispatcher: AppDispatching) {
        self.assetDataLoader = assetDataLoader
        self.appDispatcher = appDispatcher
        backgroundQueue = appDispatcher.makeBackgroundQueue()
    }

    func updateView(running runner: AsyncRunner<AssetCollectionPresenterResponse>) {

        runner.run(.loading(show: true))

        assetDataLoader.load(completionQueue: backgroundQueue) { [weak self] (response) in

            guard let strongSelf = self else { return }
            var presenterResponse: AssetCollectionPresenterResponse

            switch response {
            case .success(let assetDataModelList):
                presenterResponse = strongSelf.presenterResponseFromSuccessDataModelList(assetDataModelList: assetDataModelList)

            case .error:
                // do something better with the error here
                presenterResponse = .error(title: "error", msg: "this is an error message")
            }

            runner.run(.loading(show: false))
            runner.run(presenterResponse)
        }
	}
}

// MARK: Utils

extension AssetCollectionPresenter {

    private func presenterResponseFromSuccessDataModelList(assetDataModelList: [AssetDataModel]) -> AssetCollectionPresenterResponse {
        let viewModelList = makeViewModelsList(dataModelList: assetDataModelList)
        if viewModelList.count == 0 {
            return .noResults(title:"title", msg:"no results try again later")
        }
        return .success(viewModelList)
    }

    private func makeViewModelsList(dataModelList: [AssetDataModel]) -> [AssetViewModel] {
        return dataModelList.map { AssetViewModel(id: $0.id, title: $0.title, imageUrl: $0.imageUrl) }
    }
}
