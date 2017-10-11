//
//  AssetCollectionPresenterTests.swift
//  ExampleTests
//
//  Created by Richard Moult on 11/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example


class AssetCollectionPresenterTests: XCTestCase {

    typealias responseHandlerType = (AssetCollectionPresenterResponse)->()
    var stubAssetDataLoader: StubAssetDataLoader!
    var presenter: AssetCollectionPresenter!


    override func setUp() {
        stubAssetDataLoader = StubAssetDataLoader()
        presenter = AssetCollectionPresenter(assetDataLoader: stubAssetDataLoader)
        super.setUp()
    }

    override func tearDown() {
        stubAssetDataLoader = nil
        presenter = nil
        super.tearDown()
    }

    private func updateViewExpectLoading(presenter: AssetCollectionPresenter) -> Bool? {
        var isLoading: Bool?
        presenter.updateView { response in
            switch response {
            case .loading(let show):
                isLoading = show
            default:
                break
            }
        }
        return isLoading
    }

    private func updateViewExpectError(presenter: AssetCollectionPresenter) -> (title:String, msg:String)? {
        var result: (title:String, msg:String)?
        presenter.updateView { response in
            switch response {
            case .error(let title, let msg):
                result?.title = title
                result?.msg = msg
            default:
                break
            }
        }
        return result
    }

}

// MARK: Response Loading

extension AssetCollectionPresenterTests {

    func test_updateView_respondsWithShowLoadingTrue() {
        let isLoading = updateViewExpectLoading(presenter: presenter)
        XCTAssertTrue(isLoading!)
    }

    func test_updateView_onAssetDataLoadingCompletion_respondsWithShowLoadingFalse() {
        stubAssetDataLoader.stubResponse = AssetDataLoaderResponse.error(NSError())
        let isLoading = updateViewExpectLoading(presenter: presenter)
        XCTAssertFalse(isLoading!)
    }
}

// MARK: Response Error

extension AssetCollectionPresenterTests {

//    func test_updateView_onDataLoadingError_respondsWithError() {
//        stubAssetDataLoader.stubResponse = AssetDataLoaderResponse.error(NSError())
//
//        var result: (title:String, msg:String)?
//        presenter.updateView { response in
//            switch response {
//            case .error(let title, let msg):
//                result?.title = title
//                result?.msg = msg
//            default:
//                break
//            }
//        }
//
//        XCTAssertEqual(result?.title, "error")
//        XCTAssertEqual(result?.msg, "this is an error message")
//    }

}
