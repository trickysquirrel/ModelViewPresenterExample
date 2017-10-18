//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example

class StubAssetSearchPresenter: AssetSearchPresenting {

    private(set) var didCallUpdateSearchResultsWithString: String?
    var updateHandler: updateHandlerType?

    func navigationTitle() -> String {
        return "search test title"
    }

    func searchBarPlaceHolderText() -> String {
        return "not tested yet as could not figure out how to get search bar to initialise"
    }

    func updateSearchResults(searchString: String, updateHandler: @escaping updateHandlerType) {
        didCallUpdateSearchResultsWithString = searchString
        self.updateHandler = updateHandler
    }
}


class AssetSearchViewControllerTests: XCTestCase {

    var searchController: UISearchController!
    var viewController: AssetSearchViewController!
    var stubPresenter: StubAssetSearchPresenter!
    var stubLoadingIndicator: StubLoadingIndicator!
    var stubConfigureCollectionView: StubConfigureCollectionView!
    var dataSource: CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>!



    override func setUp() {
        super.setUp()
        dataSource = CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>()
        stubConfigureCollectionView = StubConfigureCollectionView()
        stubLoadingIndicator = StubLoadingIndicator()
        stubPresenter = StubAssetSearchPresenter()
        searchController = UISearchController()
        viewController = makeViewController(configureCollectionView: stubConfigureCollectionView)
    }

    override func tearDown() {
        dataSource = nil
        stubConfigureCollectionView = nil
        stubPresenter = nil
        searchController = nil
        viewController = nil
        super.tearDown()
    }

    private func makeViewController(configureCollectionView: CollectionViewConfigurable) -> AssetSearchViewController {
        let viewController = AssetSearchViewController(searchController: searchController,
                                                       presenter: stubPresenter,
                                                       loadingIndicator: stubLoadingIndicator,
                                                       configureCollectionView: configureCollectionView,
                                                       dataSource: dataSource)
        viewController.beginAppearanceTransition(true, animated: false)
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

}

// MARK: view did load

extension AssetSearchViewControllerTests {

    func test_viewDidLoad_navigationTitleCorrect() {
        XCTAssertEqual(viewController.title, stubPresenter.navigationTitle())
    }

    func test_viewDidLoad_configuresSearchController() {
        XCTAssertTrue(searchController.searchResultsUpdater === viewController)
        XCTAssertFalse(searchController.obscuresBackgroundDuringPresentation)
        //XCTAssertEqual(searchController.searchBar.placeholder, "enter title")// need to figure out why this s failing
        XCTAssertTrue(viewController.definesPresentationContext)
    }

    func test_onViewLoad_configuresCollectionView() {
        XCTAssertTrue(stubConfigureCollectionView.didCallConfigure)
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

        stubPresenter.updateHandler!(.loading(show: true))

        XCTAssertTrue(stubLoadingIndicator.didCallStatusBarWithLoading!)
        XCTAssertTrue(stubLoadingIndicator.didCallViewWithLoading!)
        XCTAssertEqual(stubLoadingIndicator.didCallViewWithView!, viewController.view!)
    }


    func test_onPresenterResponse_loadingFalse_setStatusBarAndVisualLoadingViewToFalse() {

        updateViewController(viewController, withSearchText: "t")

        stubPresenter.updateHandler!(.loading(show: false))

        XCTAssertFalse(stubLoadingIndicator.didCallStatusBarWithLoading!)
        XCTAssertFalse(stubLoadingIndicator.didCallViewWithLoading!)
        XCTAssertEqual(stubLoadingIndicator.didCallViewWithView!, viewController.view!)
    }
    

    func test_onPresenterResponse_information_showsInformationToUser() {

        updateViewController(viewController, withSearchText: "t")

        stubPresenter.updateHandler!(.information("in a test"))

        XCTAssertEqual(viewController.informationLabel.text, "in a test")
    }


    func test_onPresenterResponse_success_setsUpDataSourceWithViewModesl() {

        let viewModels = makeTwoAssetViewModelList()
        updateViewController(viewController, withSearchText: "t")

        stubPresenter.updateHandler!(.success(viewModels))

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

        stubPresenter.updateHandler!(.success(viewModelList))

        let collectionView = newViewController.collectionView!
        let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAt: indexPath) as! AssetCollectionViewCell

        XCTAssertEqual(cell.labelTitle.text, viewModelList[1].title)
    }

}


