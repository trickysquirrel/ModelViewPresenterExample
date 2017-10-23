//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example



class AssetSearchPresentingTests: XCTestCase {

    var presenter: AssetSearchPresenting!
    var stubSearchDataLoader: StubSearchDataLoader!
    var stubThrottle: StubThrottle!
    
    override func setUp() {
        super.setUp()
        stubThrottle = StubThrottle()
        stubSearchDataLoader = StubSearchDataLoader()
        presenter = AssetSearchPresenter(throttle: stubThrottle, searchDataLoader: stubSearchDataLoader, appDispatcher: FakeAppDispatcher())
    }
    
    override func tearDown() {
        stubThrottle = nil
        presenter = nil
        stubSearchDataLoader = nil
        super.tearDown()
    }


    private func makeTwoSearchDataModelList() -> [SearchDataModel] {
        let dataModel1 = SearchDataModel(id: 1, title: "a", imageUrl: URL(string:"dummyA")!)
        let dataModel2 = SearchDataModel(id: 2, title: "b", imageUrl: URL(string:"dummyB")!)
        return [dataModel1, dataModel2]
    }


    func test_navigationTitle_returnsCorrectString() {
        XCTAssertEqual(presenter.navigationTitle(), "Search")
    }


    func test_searchBarPlaceHolderText_returnsCorrectString() {
        XCTAssertEqual(presenter.searchBarPlaceHolderText(), "enter title")
    }


    func test_updateSearchResults_entersOneChar_returnsTextToEnterMoreChars() {
        var responseInformation: String?
        presenter.updateSearchResults(searchString: "a") { (response) in
            switch response {
            case .information(let msg):
                responseInformation = msg
            default:
                break
            }
        }
        XCTAssertEqual(responseInformation, "enter min 3 characters")
    }


    func test_updateSearchResults_entersThreeChar_returnsEmptyInformationStringAndLoadingTrue() {
        var responseInformation: String?
        var loading: Bool?
        presenter.updateSearchResults(searchString: "abc") { (response) in
            switch response {
            case .information(let msg):
                responseInformation = msg
            case .loading(let showLoading):
                loading = showLoading
            default:
                break
            }
        }
        XCTAssertEqual(responseInformation, "")
        XCTAssertTrue(loading!)
    }


    func test_updateSearchResults_entersThreeChar_makesRequestForSearchResults() {
        presenter.updateSearchResults(searchString: "abc") { (response) in }
        XCTAssertEqual(stubSearchDataLoader.didRequestSearchString.count, 1)
        XCTAssertEqual(stubSearchDataLoader.didRequestSearchString[0], "abc")
    }


    func test_updateSearchResults_entersThreeChar_callsThrottleWithCorrectInfo() {
        presenter.updateSearchResults(searchString: "abc") { (response) in }
        XCTAssertEqual(stubThrottle.didCallWithDelay, 0.3)
        XCTAssertEqual(stubThrottle.didCallWithObject, "abc")
    }


    func test_updateSearchResult_throttleDoesNotReturn_searchDataNotLoaded() {
        stubThrottle.shouldReturnValue = false
        presenter.updateSearchResults(searchString: "abc") { (response) in }
        XCTAssertEqual(stubSearchDataLoader.didRequestSearchString.count, 0)
    }


    func test_updateSearchResult_throttleDoesNotReturn_doesNotRecevieLoadingResponse() {
        stubThrottle.shouldReturnValue = false
        var loading: Bool?
        presenter.updateSearchResults(searchString: "abc") { (response) in
            switch response {
            case .loading(let showLoading):
                loading = showLoading
            default:
                break
            }
        }
        XCTAssertNil(loading)
    }


    func test_updateSearchResults_loadDataReturnsError_respondsLoadingFalseWithCorrectInfomationText() {
        var responseInformation: String?
        var loading: Bool?
        stubSearchDataLoader.response = .error( NSError(domain: "", code: 0, userInfo: nil) )
        presenter.updateSearchResults(searchString: "abc") { (response) in
            switch response {
            case .information(let msg):
                responseInformation = msg
            case .loading(let showLoading):
                loading = showLoading
            default:
                break
            }
        }
        XCTAssertEqual(responseInformation, "there was an error please try again")
        XCTAssertFalse(loading!)
    }


    func test_updateSearchResults_loadDataReturnsNoData_respondsLoadingFalseWithCorrectInformationText() {
        var responseInformation: String?
        var loading: Bool?
        stubSearchDataLoader.response = .success([])
        presenter.updateSearchResults(searchString: "abc") { (response) in
            switch response {
            case .information(let msg):
                responseInformation = msg
            case .loading(let showLoading):
                loading = showLoading
            default:
                break
            }
        }
        XCTAssertEqual(responseInformation, "no results please try again")
        XCTAssertFalse(loading!)
    }


    func test_updateSearchResults_loadDataReturnsWithData_respondsLoadingFalseWithCorrectInformationText() {
        var responseInformation: String?
        var responseLoading: Bool?
        var responseViewModelList: [AssetViewModel]?
        stubSearchDataLoader.response = .success(makeTwoSearchDataModelList())
        presenter.updateSearchResults(searchString: "abc") { (response) in
            switch response {
            case .information(let msg):
                responseInformation = msg
            case .loading(let showLoading):
                responseLoading = showLoading
            case .success(let viewModelList):
                responseViewModelList = viewModelList
            }
        }
        XCTAssertEqual(responseViewModelList!.count, 2)
        XCTAssertEqual(responseInformation, "")
        XCTAssertFalse(responseLoading!)
    }

    // TODO:
    // if requesting another search then delete the old one and create a new one
    
}
