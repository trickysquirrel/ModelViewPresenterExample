//
//  AssetSearchPresenter.swift
//  Example
//
//  Created by Richard Moult on 18/10/17.
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

struct AssetSearchPresenter: AssetSearchPresenting {

    func navigationTitle() -> String {
        return "Search"
    }

    func searchBarPlaceHolderText() -> String {
        return "enter title"
    }

    func updateSearchResults(searchString: String, updateHandler: @escaping updateHandlerType) {
    }
}
