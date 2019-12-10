//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation


struct AssetViewModel {
    let id: String
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

	let interactor: AssetCollectionInteracting
    let backgroundQueue: DispatchQueue

    
    init(interactor: AssetCollectionInteracting, appDispatcher: AppDispatching) {
        self.interactor = interactor
        backgroundQueue = appDispatcher.makeBackgroundQueue()
    }

    func updateView(running runner: AsyncRunner<AssetCollectionPresenterResponse>) {

        runner.run(.loading(show: true))

        interactor.load(running: .on(backgroundQueue) { [weak self] (response) in

            guard let self = self else { return }
            var presenterResponse: AssetCollectionPresenterResponse

            switch response {
            case .success(let items):
                presenterResponse = self.presenterResponseFromSuccessDataModelList(assetItems: items)

            case .failure:
                // do something better with the error here
                presenterResponse = .error(title: "error", msg: "this is an error message")
            }

            runner.run(.loading(show: false))
            runner.run(presenterResponse)
        })
	}
}

// MARK: Utils

extension AssetCollectionPresenter {

    private func presenterResponseFromSuccessDataModelList(assetItems: [AssetItem]) -> AssetCollectionPresenterResponse {
        let viewModelList = makeViewModelsList(assetItems: assetItems)
        if viewModelList.count == 0 {
            return .noResults(title:"title", msg:"no results try again later")
        }
        return .success(viewModelList)
    }

    private func makeViewModelsList(assetItems: [AssetItem]) -> [AssetViewModel] {
        return assetItems.map { AssetViewModel(id: $0.id, title: $0.title, imageUrl: $0.image.url) }
    }
}
