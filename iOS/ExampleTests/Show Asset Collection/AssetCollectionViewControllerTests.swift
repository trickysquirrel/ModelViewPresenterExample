//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example


class AssetCollectionViewControllerTests: XCTestCase {

    var viewController: AssetCollectionViewController!
    var stubConfigureCollectionView: StubConfigureCollectionView!
    var stubReporter: StubThirdPartyAnalyticsReporter!
    var stubPresenter: StubAssetCollectionPresenter!
    var dataSource: CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>!
    var stubLoadingIndicator: StubLoadingIndicator!
    var stubAppActions: StubAssetCollectionCoordinatorActions!

    override func setUp() {
        super.setUp()
        stubAppActions = StubAssetCollectionCoordinatorActions()
        stubConfigureCollectionView = StubConfigureCollectionView()
        viewController = makeViewController(appActions: stubAppActions, configureCollectionView: stubConfigureCollectionView)
    }
    
    override func tearDown() {
        stubAppActions = nil
        stubLoadingIndicator = nil
        dataSource = nil
        stubPresenter = nil
        stubReporter = nil
        stubConfigureCollectionView = nil
        viewController = nil
        super.tearDown()
    }
}

// MARK: View controller life cycle

extension AssetCollectionViewControllerTests {

    func test_onViewLoad_navigationTitleCorrect() {
        startViewControllerLifeCycle(viewController)
        XCTAssertEqual(viewController.title, "Movies")
    }


    func test_onViewLoad_configuresCollectionView() {
        startViewControllerLifeCycle(viewController)
        XCTAssertTrue(stubConfigureCollectionView.didCallConfigure)
    }


    func test_onViewDidAppear_sendCorrectAnalyticsActionAndData() {
        startViewControllerLifeCycle(viewController, forceViewDidAppear: true)
        XCTAssertEqual(stubReporter.sentActionList.count, 1)
        XCTAssertEqual(stubReporter.sentActionList[0].name, "MoviesCollectionShown")
        XCTAssertEqual(stubReporter.sentActionList[0].data?.keys.count, 1)
        XCTAssertEqual(stubReporter.sentActionList[0].data?["lifecycle"] as? String, "show")
    }


    func test_onViewDidAppear_eachCall_sendCorrectAnalyticsActionAndData() {

        startViewControllerLifeCycle(viewController, forceViewDidAppear: true)
        startViewControllerLifeCycle(viewController, forceViewDidAppear: true)

        XCTAssertEqual(stubReporter.sentActionList.count, 2)
        XCTAssertEqual(stubReporter.sentActionList[1].name, "MoviesCollectionShown")
        XCTAssertEqual(stubReporter.sentActionList[1].data?.keys.count, 1)
        XCTAssertEqual(stubReporter.sentActionList[1].data?["lifecycle"] as? String, "show")
    }
}

// MARK: Presenter responses

extension AssetCollectionViewControllerTests {

    func test_onPresenterResponse_loadingFalse_setStatusBarAndVisualViewFalse() {

        startViewControllerLifeCycle(viewController, forceViewDidAppear: true)

        stubPresenter.runner?.run(.loading(show: false))

        XCTAssertFalse(stubLoadingIndicator.didCallStatusBarWithLoading!)
        XCTAssertFalse(stubLoadingIndicator.didCallViewWithLoading!)
        XCTAssertEqual(stubLoadingIndicator.didCallViewWithView!, viewController.view!)
    }


    func test_onPresenterResponse_loadingTrue_setStatusBarAndVisualViewTrue() {

        startViewControllerLifeCycle(viewController, forceViewDidAppear: true)

        stubPresenter.runner?.run(.loading(show: true))

        XCTAssertTrue(stubLoadingIndicator.didCallStatusBarWithLoading!)
        XCTAssertTrue(stubLoadingIndicator.didCallViewWithLoading!)
        XCTAssertEqual(stubLoadingIndicator.didCallViewWithView!, viewController.view!)
    }


    func test_onPresenterResponse_error_showAlertWithCorrectInformation() {

        startViewControllerLifeCycle(viewController, forceViewDidAppear: true)

        stubPresenter.runner?.run(.error(title:"test title", msg:"test msg"))
        
        XCTAssertEqual(stubAppActions.didCallShowAlertWithTitle!, "test title")
        XCTAssertEqual(stubAppActions.didCallShowAlertWithMsg!, "test msg")
        XCTAssertEqual(stubAppActions.didCallShowAlertWithVC!, viewController)
    }


    func test_onPresenterResponse_noResults_showsAlertWithCorrectInformation() {

        startViewControllerLifeCycle(viewController, forceViewDidAppear: true)

        stubPresenter.runner?.run(.noResults(title:"test results", msg:"a msg"))

        XCTAssertEqual(stubAppActions.didCallShowAlertWithTitle!, "test results")
        XCTAssertEqual(stubAppActions.didCallShowAlertWithMsg!, "a msg")
        XCTAssertEqual(stubAppActions.didCallShowAlertWithVC!, viewController)
    }


    func test_onPresenterResponse_success_setCorrectSectionsAndRows() {

        startViewControllerLifeCycle(viewController, forceViewDidAppear: true)

        stubPresenter.runner?.run(.success(makeTwoAssetViewModelList()))

        XCTAssertEqual(dataSource.numberOfSections(in: self.viewController.collectionView!), 1)
        XCTAssertEqual(dataSource.collectionView(self.viewController.collectionView!, numberOfItemsInSection: 0), 2)
    }
}

// MARK: Data source events

extension AssetCollectionViewControllerTests {

    func test_onDataSource_onCellSelected_callsAppAction() {

        startViewControllerLifeCycle(viewController, forceViewDidAppear: true)
        stubPresenter.runner?.run(.success(makeTwoAssetViewModelList()))

        viewController.collectionView!.delegate!.collectionView!(viewController.collectionView!, didSelectItemAt: IndexPath(row: 1, section: 0))
        XCTAssertEqual(stubAppActions.didCallShowDetailsWithId, "2")
        XCTAssertEqual(stubAppActions.didCallShowDetailsWithTitle, "b")
    }


    func test_onDataSource_cellForIndexPath_configuresCellCorrectly() {

        let viewModelList = makeTwoAssetViewModelList()
        let indexPath = IndexPath(row: 1, section: 0)

        let configureCollectionView = ConfigureCollectionView()
        let newViewController = makeViewController(appActions: stubAppActions, configureCollectionView: configureCollectionView)
        startViewControllerLifeCycle(newViewController, forceViewDidAppear: true)
        stubPresenter.runner?.run(.success(viewModelList))

        let collectionView = newViewController.collectionView!
        let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAt: indexPath) as! AssetCollectionViewCell

        XCTAssertEqual(cell.labelTitle.text, viewModelList[1].title)
    }

}

extension AssetCollectionViewControllerTests {

    private func makeViewController(appActions: StubAssetCollectionCoordinatorActions, configureCollectionView: CollectionViewConfigurable) -> AssetCollectionViewController {
        stubReporter = StubThirdPartyAnalyticsReporter()
        let analyticsFactory = AnalyticsReporterFactory(reporter: stubReporter)
        stubPresenter = StubAssetCollectionPresenter()
        dataSource = CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>()
        stubLoadingIndicator = StubLoadingIndicator()
        return AssetCollectionViewController(
            title: "Movies",
            presenter: stubPresenter,
            configureCollectionView: configureCollectionView,
            dataSource: dataSource,
            reporter: analyticsFactory.makeAssetCollectionReporter(),
            loadingIndicator: stubLoadingIndicator,
            appActions: appActions)

    }

    private func startViewControllerLifeCycle(_ viewController: UIViewController, forceViewDidAppear: Bool = false) {
        viewController.beginAppearanceTransition(true, animated: false)
        if forceViewDidAppear {
            viewController.viewDidAppear(false)
        }
    }

    private func makeTwoAssetViewModelList() -> [AssetViewModel] {
        let assetViewModel1 = AssetViewModel(id: "1", title: "a", imageUrl: URL(string:"dummyA")!)
        let assetViewModel2 = AssetViewModel(id: "2", title: "b", imageUrl: URL(string:"dummyB")!)
        return [assetViewModel1, assetViewModel2]
    }
}
