//
//  AssetCollectionViewControllerTests.swift
//  ExampleTests
//
//  Created by Richard Moult on 8/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example


// move to its own files
class StubConfigureCollectionView: CollectionViewConfigurable {

    private(set) var didCallConfigure = false

    func configure(collectionView: UICollectionView?, nibName: String, reuseIdentifier: String) {
        didCallConfigure = true
    }
}


class StubAdobeAnalyticsReporter: AdobeAnalyticsReporting {

    private(set) var sentActionList: [(name: String, data: [String:Any]?)] = []

    func sendAction(name: String, data: [String:Any]?) {
        sentActionList.append((name:name, data:data))
    }
}


class StubAssetCollectionPresenter: AssetCollectionPresenting {

    var updateHandler: CompletionAlias?

    func updateView(updateHandler: @escaping CompletionAlias) {
        self.updateHandler = updateHandler
    }
}


class StubInformationAlert: InformationAlertProtocol {

    private(set) var title: String?
    private(set) var message: String?
    private(set) var presentingViewController: UIViewController?

    func displayAlert(title: String, message: String, presentingViewController: UIViewController?) {
        self.title = title
        self.message = message
        self.presentingViewController = presentingViewController
    }
}

class StubLoadingIndicator: LoadingIndicatorProtocol {

    var didCallStatusBarWithLoading: Bool?
    var didCallViewWithLoading: Bool?
    var didCallViewWithView: UIView?

    func statusBar(_ loading: Bool) {
        didCallStatusBarWithLoading = loading
    }

    func view(view: UIView, loading: Bool) {
        didCallViewWithLoading = loading
        didCallViewWithView = view
    }

}


class AssetCollectionViewControllerTests: XCTestCase {

    var viewController: AssetCollectionViewController!
    var stubConfigureCollectionView: StubConfigureCollectionView!
    var stubAdobeAnalyticsReporter: StubAdobeAnalyticsReporter!
    var stubPresenter: StubAssetCollectionPresenter!
    var stubInformationAlert: StubInformationAlert!
    var dataSource: CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>!
    var stubLoadingIndicator: StubLoadingIndicator!

    override func setUp() {
        super.setUp()
        let appActions = AppMovieCollectionActions {}
        viewController = makeViewController(appActions: appActions)
    }
    
    override func tearDown() {
        stubLoadingIndicator = nil
        dataSource = nil
        stubInformationAlert = nil
        stubPresenter = nil
        stubAdobeAnalyticsReporter = nil
        stubConfigureCollectionView = nil
        viewController = nil
        super.tearDown()
    }

    private func makeViewController(appActions: AppMovieCollectionActions) -> AssetCollectionViewController {
        stubAdobeAnalyticsReporter = StubAdobeAnalyticsReporter()
        let analyticsFactory = AnalyticsReporterFactory(adobeAnalyticsReporter: stubAdobeAnalyticsReporter)
        stubPresenter = StubAssetCollectionPresenter()
        dataSource = CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>()
        stubConfigureCollectionView = StubConfigureCollectionView()
        stubInformationAlert = StubInformationAlert()
        stubLoadingIndicator = StubLoadingIndicator()
        return AssetCollectionViewController(presenter: stubPresenter,
                                             configureCollectionView: stubConfigureCollectionView,
                                             dataSource: dataSource,
                                             reporter: analyticsFactory.makeAssetCollectionReporter(),
                                             loadingIndicator: stubLoadingIndicator,
                                             alert: stubInformationAlert,
                                             appActions: appActions)

    }

    private func startViewControllerLifeCycle(_ viewController: UIViewController, forceViewDidAppear: Bool = false) {
        viewController.beginAppearanceTransition(true, animated: false)
        if forceViewDidAppear {
            viewController.viewDidAppear(false)
        }
    }

    private func makeTwoAssetViewModelList() -> [AssetViewModel] {
        let assetViewModel = AssetViewModel(title: "", imageUrl: URL(string:"dummy")!)
        return [assetViewModel, assetViewModel]
    }
}

// MARK: View controller life cycle

extension AssetCollectionViewControllerTests {

    func test_onViewLoad_configuresCollectionView() {
        startViewControllerLifeCycle(viewController)
        XCTAssertTrue(stubConfigureCollectionView.didCallConfigure)
    }


    func test_onViewDidAppear_sendCorrectAnalyticsActionAndData() {

        startViewControllerLifeCycle(viewController, forceViewDidAppear: true)

        XCTAssertEqual(stubAdobeAnalyticsReporter.sentActionList.count, 1)
        XCTAssertEqual(stubAdobeAnalyticsReporter.sentActionList[0].name, "MoviesCollectionShown")
        XCTAssertEqual(stubAdobeAnalyticsReporter.sentActionList[0].data?.keys.count, 1)
        XCTAssertEqual(stubAdobeAnalyticsReporter.sentActionList[0].data?["test"] as! String, "something")
    }
}

// MARK: Presenter responses

extension AssetCollectionViewControllerTests {

    func test_onPresenterResponse_loadingFalse_setStatusBarAndVisualViewFalse() {

        startViewControllerLifeCycle(viewController, forceViewDidAppear: true)

        stubPresenter.updateHandler!(.loading(show: false))

        XCTAssertEqual(stubLoadingIndicator.didCallStatusBarWithLoading!, false)
        XCTAssertEqual(stubLoadingIndicator.didCallViewWithLoading!, false)
        XCTAssertEqual(stubLoadingIndicator.didCallViewWithView!, viewController.view!)
    }


    func test_onPresenterResponse_loadingTrue_setStatusBarAndVisualViewTrue() {

        startViewControllerLifeCycle(viewController, forceViewDidAppear: true)

        stubPresenter.updateHandler!(.loading(show: true))

        XCTAssertEqual(stubLoadingIndicator.didCallStatusBarWithLoading!, true)
        XCTAssertEqual(stubLoadingIndicator.didCallViewWithLoading!, true)
        XCTAssertEqual(stubLoadingIndicator.didCallViewWithView!, viewController.view!)
}


    func test_onPresenterResponse_error_showAlertWithCorrectInformation() {

        startViewControllerLifeCycle(viewController, forceViewDidAppear: true)

        stubPresenter.updateHandler!(.error(title:"test title", msg:"test msg"))
        
        XCTAssertEqual(stubInformationAlert.title!, "test title")
        XCTAssertEqual(stubInformationAlert.message!, "test msg")
        XCTAssertEqual(stubInformationAlert.presentingViewController!, viewController)
    }


    func test_onPresenterResponse_noResults_showsAlertWithCorrectInformation() {

        startViewControllerLifeCycle(viewController, forceViewDidAppear: true)

        stubPresenter.updateHandler!(.noResults(title:"test results", msg:"a msg"))

        XCTAssertEqual(stubInformationAlert.title!, "test results")
        XCTAssertEqual(stubInformationAlert.message!, "a msg")
        XCTAssertEqual(stubInformationAlert.presentingViewController!, viewController)
    }


    func test_onPresenterResponse_success_setCorrectSectionsAndRows() {

        startViewControllerLifeCycle(viewController, forceViewDidAppear: true)

        stubPresenter.updateHandler!(.success(makeTwoAssetViewModelList()))

        XCTAssertEqual(dataSource.numberOfSections(in: viewController.collectionView!), 1)
        XCTAssertEqual(dataSource.collectionView(viewController.collectionView!, numberOfItemsInSection: 0), 2)
    }
}

// MARK: Presenter responses

extension AssetCollectionViewControllerTests {

    func test_onDataSource_onCellSelected_callsAppAction() {

        var didCallAppAction = false
        let newAppActions = AppMovieCollectionActions {
            didCallAppAction = true
        }

        let newViewController = makeViewController(appActions: newAppActions)
        startViewControllerLifeCycle(newViewController, forceViewDidAppear: true)
        stubPresenter.updateHandler!(.success(makeTwoAssetViewModelList()))

        newViewController.collectionView!.delegate!.collectionView!(viewController.collectionView!, didSelectItemAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(didCallAppAction)
    }

}
