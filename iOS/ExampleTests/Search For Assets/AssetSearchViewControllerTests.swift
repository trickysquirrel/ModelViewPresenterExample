//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example


class AssetSearchViewControllerTests: XCTestCase {

    var searchController: UISearchController!
    var viewController: AssetSearchViewController!
    var stubPresenter: StubAssetSearchPresenter!
    var stubLoadingIndicator: StubLoadingIndicator!
    var stubConfigureCollectionView: StubConfigureCollectionView!
    var dataSource: CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>!
    var stubReporter: StubThirdPartyAnalyticsReporter!

    override func setUp() {
        super.setUp()
        stubReporter = StubThirdPartyAnalyticsReporter()
        dataSource = CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>()
        stubConfigureCollectionView = StubConfigureCollectionView()
        stubLoadingIndicator = StubLoadingIndicator()
        stubPresenter = StubAssetSearchPresenter()
        searchController = UISearchController()
        viewController = makeViewController(configureCollectionView: stubConfigureCollectionView)
    }

    override func tearDown() {
        stubReporter = nil
        dataSource = nil
        stubConfigureCollectionView = nil
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
        XCTAssertEqual(searchController.searchBar.placeholder, "enter title")
        XCTAssertTrue(viewController.definesPresentationContext)
    }

    func test_onViewLoad_configuresCollectionView() {
        XCTAssertTrue(stubConfigureCollectionView.didCallConfigure)
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

    func test_onPresenterResponse_loadingTrue_setStatusBarAndVisualLoadingViewToTrue() {

        updateViewController(viewController, withSearchText: "t")

        stubPresenter.runner?.run(.loading(show: true))

        XCTAssertTrue(stubLoadingIndicator.didCallStatusBarWithLoading!)
        XCTAssertTrue(stubLoadingIndicator.didCallViewWithLoading!)
        XCTAssertEqual(stubLoadingIndicator.didCallViewWithView!, viewController.view!)
    }


    func test_onPresenterResponse_loadingFalse_setStatusBarAndVisualLoadingViewToFalse() {

        updateViewController(viewController, withSearchText: "t")

        stubPresenter.runner?.run(.loading(show: false))

        XCTAssertFalse(stubLoadingIndicator.didCallStatusBarWithLoading!)
        XCTAssertFalse(stubLoadingIndicator.didCallViewWithLoading!)
        XCTAssertEqual(stubLoadingIndicator.didCallViewWithView!, viewController.view!)
    }
    

    func test_onPresenterResponse_information_showsInformationToUser() {

        updateViewController(viewController, withSearchText: "t")

        stubPresenter.runner?.run(.information("in a test"))

        XCTAssertEqual(viewController.informationLabel.text, "in a test")
    }


    func test_onPresenterResponse_success_setsUpDataSourceWithViewModesl() {

        let viewModels = makeTwoAssetViewModelList()
        updateViewController(viewController, withSearchText: "t")

        stubPresenter.runner?.run(.success(viewModels))

        XCTAssertEqual(dataSource.numberOfSections(in: self.viewController.collectionView!), 1)
        XCTAssertEqual(dataSource.collectionView(self.viewController.collectionView!, numberOfItemsInSection: 0), 2)
    }
}


// MARK: Data source events

extension AssetSearchViewControllerTests {

    func test_onDataSource_cellForIndexPath_configuresCellCorrectly() {

        let viewModelList = makeTwoAssetViewModelList()
        let indexPath = IndexPath(row: 1, section: 0)

        let newViewController = makeViewController(configureCollectionView: ConfigureCollectionView())

        updateViewController(newViewController, withSearchText: "t")

        stubPresenter.runner?.run(.success(viewModelList))

        let collectionView = newViewController.collectionView!
        let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAt: indexPath) as! AssetCollectionViewCell

        XCTAssertEqual(cell.labelTitle.text, viewModelList[1].title)
    }

}

extension AssetSearchViewControllerTests {

    private func makeViewController(configureCollectionView: CollectionViewConfigurable) -> AssetSearchViewController {
        let analyticsFactory = AnalyticsReporterFactory(reporter: stubReporter)
        let viewController = AssetSearchViewController(searchController: searchController,
                                                       presenter: stubPresenter,
                                                       loadingIndicator: stubLoadingIndicator,
                                                       configureCollectionView: configureCollectionView,
                                                       dataSource: dataSource,
                                                       reporter: analyticsFactory.makeSearchReporter())
        startViewControllerLifeCycle(viewController, forceViewDidAppear: false)
        return viewController
    }

    private func makeTwoAssetViewModelList() -> [AssetViewModel] {
        let assetViewModel1 = AssetViewModel(id: 1, title: "a", imageUrl: URL(string:"dummyA")!)
        let assetViewModel2 = AssetViewModel(id: 2, title: "b", imageUrl: URL(string:"dummyB")!)
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
