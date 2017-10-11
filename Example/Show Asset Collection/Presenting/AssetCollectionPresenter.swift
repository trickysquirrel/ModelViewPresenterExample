//
//  MoviesPresenter.swift
//  Example
//
//  Created by Richard Moult on 4/10/17.
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
    typealias CompletionAlias = (AssetCollectionPresenterResponse)->()
    func updateView(updateHandler: @escaping CompletionAlias)
}


class AssetCollectionPresenter: AssetCollectionPresenting {

	let assetDataLoader: AssetDataLoading

    init(assetDataLoader: AssetDataLoading) {
        self.assetDataLoader = assetDataLoader
    }

    func updateView(updateHandler:@escaping CompletionAlias) {

        updateHandler(.loading(show: true))

        let backgroundQueue = DispatchQueue.global(qos: .background)

        assetDataLoader.load(completionQueue: backgroundQueue) { [weak self] (response) in

            guard let strongSelf = self else { return }
            var presenterResponse: AssetCollectionPresenterResponse

            switch response {
            case .success(let assetDataModelList):
                let viewModelList = strongSelf.makeViewModelsList(dataModelList: assetDataModelList)
                if viewModelList.count == 0 {
                    presenterResponse = .noResults(title:"title", msg:"no results try again later")
                }
                else {
                    presenterResponse = .success(viewModelList)
                }

            case .error:
                // do something better with the error here
                presenterResponse = .error(title: "error", msg: "this is an error message")
            }

            DispatchQueue.main.async {
                updateHandler(.loading(show: false))
                updateHandler(presenterResponse)
            }
        }
	}
}

// MARK: Utils

extension AssetCollectionPresenter {

    private func makeViewModelsList(dataModelList: [AssetDataModel]) -> [AssetViewModel] {
        return dataModelList.map { AssetViewModel(id: $0.id, title: $0.title, imageUrl: $0.imageUrl) }
    }
}
