//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example


class AssetSearchViewControllerTests: XCTestCase {

    var searchController: UISearchController!
    var viewController: AssetSearchViewController!
    var stubPresenter: StubAssetSearchPresenter!
    var stubReporter: StubThirdPartyAnalyticsReporter!
    let fakeSearchViewController = UIViewController()

    override func setUp() {
        super.setUp()
        stubReporter = StubThirdPartyAnalyticsReporter()
        stubPresenter = StubAssetSearchPresenter()
        searchController = UISearchController()
        viewController = makeViewController()
    }

    override func tearDown() {
        stubReporter = nil
        stubPresenter = nil
        searchController = nil
        viewController = nil
        super.tearDown()
    }
}

// MARK: view did load

extension AssetSearchViewControllerTests {

    func test_viewDidLoad_configuresSearchController() {
        XCTAssertTrue(searchController.searchResultsUpdater === viewController)
        XCTAssertFalse(searchController.obscuresBackgroundDuringPresentation)
        XCTAssertTrue(viewController.definesPresentationContext)
    }


    func test_onViewDidAppear_sendCorrectAnalyticsActionAndData() {
        startViewControllerLifeCycle(viewController, forceViewDidAppear: true)
        XCTAssertEqual(stubReporter.sentActionList.count, 1)
        XCTAssertEqual(stubReporter.sentActionList[0].name, "Search")
        XCTAssertEqual(stubReporter.sentActionList[0].data?["lifecycle"] as? String, "show")
    }


    func test_onViewDidAppear_eachCall_sendCorrectAnalyticsActionAndData() {
        startViewControllerLifeCycle(viewController, forceViewDidAppear: true)
        startViewControllerLifeCycle(viewController, forceViewDidAppear: true)
        XCTAssertEqual(stubReporter.sentActionList.count, 2)
        XCTAssertEqual(stubReporter.sentActionList[1].name, "Search")
        XCTAssertEqual(stubReporter.sentActionList[0].data?["lifecycle"] as? String, "show")
    }

}

// MARK: search bar update text

extension AssetSearchViewControllerTests {

    func test_updateSearchResults_callsPresenterWithSearchString() {
        updateViewController(viewController, withSearchText: "t")
        XCTAssertEqual(stubPresenter.didCallUpdateSearchResultsWithString!, "t")
    }
}

// MARK: presenter responses

extension AssetSearchViewControllerTests {

    func test_onPresenterResponse_information_showsInformationToUser() {
        updateViewController(viewController, withSearchText: "t")
        stubPresenter.runner?.run(.information("in a test"))
        XCTAssertEqual(viewController.informationLabel.text, "in a test")
    }

    func test_presenter_returns_validSearchText_viewController_should_have_searchResults_child() {
        updateViewController(viewController, withSearchText: "t")
        stubPresenter.runner?.run(.success("test"))
        XCTAssertEqual(viewController.children.count, 1)
        XCTAssertEqual(viewController.children[0], fakeSearchViewController)
    }

    func test_presenter_returns_clearSearchResults_should_remove_searchResults_child() {
        updateViewController(viewController, withSearchText: "t")
        stubPresenter.runner?.run(.success("test"))
        stubPresenter.runner?.run(.clearSearchResults)
        XCTAssertEqual(viewController.children.count, 0)
    }
}

extension AssetSearchViewControllerTests {

    private func makeViewController() -> AssetSearchViewController {
        let analyticsFactory = AnalyticsReporterFactory(reporter: stubReporter)
        let viewController = AssetSearchViewController(searchController: searchController,
                                                       presenter: stubPresenter,
                                                       reporter: analyticsFactory.makeSearchReporter(),
                                                       appActions: self)
        startViewControllerLifeCycle(viewController, forceViewDidAppear: false)
        return viewController
    }

    private func makeTwoAssetViewModelList() -> [AssetViewModel] {
        let assetViewModel1 = AssetViewModel(id: "1", title: "a", imageUrl: URL(string:"dummyA")!)
        let assetViewModel2 = AssetViewModel(id: "2", title: "b", imageUrl: URL(string:"dummyB")!)
        return [assetViewModel1, assetViewModel2]
    }

    private func updateViewController(_ viewController: AssetSearchViewController, withSearchText string: String) {
        viewController._updateSearchText(searchString: string)
    }

    private func startViewControllerLifeCycle(_ viewController: UIViewController, forceViewDidAppear: Bool = false) {
        viewController.beginAppearanceTransition(true, animated: false)
        if forceViewDidAppear {
            viewController.viewDidAppear(false)
        }
    }
}


extension AssetSearchViewControllerTests: SearchRouterActions {

    func makeSearchResultsViewController(searchTerm: String) -> UIViewController {
        return fakeSearchViewController
    }
}
