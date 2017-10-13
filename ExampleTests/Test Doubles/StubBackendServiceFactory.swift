//
//  StubBackendServiceFactory.swift
//  ExampleTests
//
//  Created by Richard Moult on 13/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation
@testable import Example


class StubBackendServiceFactory: BackendServiceFactoryProtocol {

    func makeMoviesAssetCollectionDataLoader() -> AssetDataLoading {
        return StubAssetDataLoader()
    }
}
