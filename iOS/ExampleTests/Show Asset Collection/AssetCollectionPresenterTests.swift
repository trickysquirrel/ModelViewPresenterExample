//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example


class AssetCollectionPresenterTests: XCTestCase {

    typealias responseHandlerType = (AssetCollectionPresenterResponse)->()
    var stubAssetDataLoader: StubAssetDataLoader!
    var presenter: AssetCollectionPresenter!
    var fakeDataModel1 = AssetDataModel(id: 1, title: "1", imageUrl: URL(string:"dummy1")!)
    var fakeDataModel2 = AssetDataModel(id: 2, title: "2", imageUrl: URL(string:"dummy2")!)


    override func setUp() {
        stubAssetDataLoader = StubAssetDataLoader()
        presenter = AssetCollectionPresenter(assetDataLoader: stubAssetDataLoader, appDispatcher: FakeAppDispatcher())
        super.setUp()
    }

    override func tearDown() {
        stubAssetDataLoader = nil
        presenter = nil
        super.tearDown()
    }
}

// MARK: Response Loading

extension AssetCollectionPresenterTests {

    func test_updateView_respondsWithShowLoadingTrue() {
        var isLoading = false
        // change this and return the presenter resposen instead, might be easier to read
        updateViewExpectLoading(presenter: presenter) { loading in
            isLoading = loading
        }
        XCTAssertTrue(isLoading)
    }
    

    func test_updateView_onAssetDataLoadingCompletion_respondsWithShowLoadingFalse() {
        stubAssetDataLoader.stubResponse = AssetDataLoaderResponse.error(NSError())
        var isLoading = true
        updateViewExpectLoading(presenter: presenter) { loading in
            isLoading = loading
        }
        XCTAssertFalse(isLoading)
    }
}

// MARK: Response Error

extension AssetCollectionPresenterTests {

    func test_updateView_onDataLoadingError_respondsWithError() {
        stubAssetDataLoader.stubResponse = AssetDataLoaderResponse.error(NSError())
        var errorTitle = "", errorMsg = ""
        updateViewExpectError(presenter: presenter) { title, msg in
            errorTitle = title
            errorMsg = msg
        }
        XCTAssertEqual(errorTitle, "error")
        XCTAssertEqual(errorMsg, "this is an error message")
    }
}

// MARK: Reponse No Results

extension AssetCollectionPresenterTests {

    func test_updateView_onDataLoadingNoResults_respondsWithError() {
        stubAssetDataLoader.stubResponse = AssetDataLoaderResponse.success([])
        var errorTitle = "", errorMsg = ""
        updateViewExpectNoResults(presenter: presenter) { title, msg in
            errorTitle = title
            errorMsg = msg
        }
        XCTAssertEqual(errorTitle, "title")
        XCTAssertEqual(errorMsg, "no results try again later")
    }
}

// MARK: Response Success

extension AssetCollectionPresenterTests {

    func test_updateView_onDataLoadingSuccess_respondsWithCorrectNumberOfViewModels() {
        stubAssetDataLoader.stubResponse = AssetDataLoaderResponse.success([fakeDataModel1, fakeDataModel2])
        var viewModelList: [AssetViewModel]?
        updateViewExpectSuccess(presenter: presenter) { viewModels in
            viewModelList = viewModels
        }
        XCTAssertEqual(viewModelList?.count, 2)
    }


    func test_updateView_onDataLoadingSuccess_respondsWithViewModelProperties() {
        stubAssetDataLoader.stubResponse = AssetDataLoaderResponse.success([fakeDataModel1, fakeDataModel2])
        var viewModelList: [AssetViewModel]?
        updateViewExpectSuccess(presenter: presenter) { viewModels in
            viewModelList = viewModels
        }

        XCTAssertEqual(viewModelList?.first?.id, fakeDataModel1.id)
        XCTAssertEqual(viewModelList?.first?.title, fakeDataModel1.title)
        XCTAssertEqual(viewModelList?.first?.imageUrl, fakeDataModel1.imageUrl)

        XCTAssertEqual(viewModelList?.last?.id, fakeDataModel2.id)
        XCTAssertEqual(viewModelList?.last?.title, fakeDataModel2.title)
        XCTAssertEqual(viewModelList?.last?.imageUrl, fakeDataModel2.imageUrl)
    }
}

extension AssetCollectionPresenterTests {

    private func updateViewExpectLoading(presenter: AssetCollectionPresenter, completion:@escaping (Bool)->Void) {
        presenter.updateView(running: .on(.main) { response in
            switch response {
            case .loading(let show):
                completion(show)
            default:
                break
            }
        })
    }

    private func updateViewExpectError(presenter: AssetCollectionPresenter, completion:@escaping (String, String)->Void) {
        presenter.updateView(running: .on(.main) { response in
            switch response {
            case .error(let title, let msg):
                completion(title, msg)
            default:
                break
            }
        })
    }

    private func updateViewExpectNoResults(presenter: AssetCollectionPresenter, completion:@escaping (String, String)->Void) {
        presenter.updateView(running: .on(.main) { response in
            switch response {
            case .noResults(let title, let msg):
                completion(title, msg)
            default:
                break
            }
        })
    }

    private func updateViewExpectSuccess(presenter: AssetCollectionPresenter, completion:@escaping ([AssetViewModel])->Void) {
        presenter.updateView(running: .on(.main) { response in
            switch response {
            case .success(let viewModelList):
                completion(viewModelList)
            default:
                break
            }
        })
    }
}
