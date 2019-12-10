//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example



class AssetSearchPresentingTests: XCTestCase {

    var presenter: AssetSearchPresenting!
    var stubThrottle: StubThrottle!
    
    override func setUp() {
        super.setUp()
        stubThrottle = StubThrottle()
        presenter = AssetSearchPresenter(throttle: stubThrottle)
    }
    
    override func tearDown() {
        stubThrottle = nil
        presenter = nil
        super.tearDown()
    }

    func test_updateSearchResults_entersZeroChar_returnsEmptyInformationAndViewModels() {
        var responseInformation: String?
        var responseSearchString: String?
        var responseClear = false
        presenter.updateSearchResults(searchString: "", running: .on(.main) { (response) in
            switch response {
            case .information(let msg):
                responseInformation = msg
            case .success(let string):
                responseSearchString = string
            case .clearSearchResults:
                responseClear = true
            }
        })
        XCTAssertEqual(responseInformation, "")
        XCTAssertNil(responseSearchString)
        XCTAssertTrue(responseClear)
    }


    func test_updateSearchResults_entersOneChar_returnsTextToEnterMoreCharsAndEmptyViewModels() {
        var responseInformation: String?
        var responseSearchString: String?
        var responseClear = false
        presenter.updateSearchResults(searchString: "a", running: .on(.main) { (response) in
            switch response {
            case .information(let msg):
                responseInformation = msg
            case .success(let string):
                responseSearchString = string
            case .clearSearchResults:
                responseClear = true
            }
        })
        XCTAssertEqual(responseInformation, "enter min 3 characters")
        XCTAssertNil(responseSearchString)
        XCTAssertTrue(responseClear)

    }


    func test_updateSearchResults_entersThreeChar_returnsEmptyInformationStringAndLoadingTrue() {
        var responseInformation: String?
        var responseSearchString: String?
        var responseClear = false
        presenter.updateSearchResults(searchString: "abc", running: .on(.main) { (response) in
            switch response {
            case .information(let msg):
                responseInformation = msg
            case .success(let string):
                responseSearchString = string
            case .clearSearchResults:
                responseClear = true
            }
        })
        XCTAssertEqual(responseInformation, "")
        XCTAssertEqual(responseSearchString, "abc")
        XCTAssertFalse(responseClear)
    }


    func test_updateSearchResults_entersThreeChar_callsThrottleWithCorrectInfo() {
        presenter.updateSearchResults(searchString: "abc", running: .on(.main) { (response) in })
        XCTAssertEqual(stubThrottle.didCallWithDelay, 0.3)
        XCTAssertEqual(stubThrottle.didCallWithObject, "abc")
    }
}
