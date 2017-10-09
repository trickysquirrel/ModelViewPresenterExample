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


struct StubAdobeAnalyticsReporter: AdobeAnalyticsReporting {

    private(set) var sentActionList: [(name: String, data: [String:Any]?)] = []

    func sendAction(name: String, data: [String:Any]?) {
        // call adobe library here and pass on the data
    }
}




class AssetCollectionAcceptanceTests: XCTestCase {

    var viewConroller: AssetCollectionViewController!
    var stubConfigureCollectionView: StubConfigureCollectionView!
    var stubAdobeAnalyticsReporter: StubAdobeAnalyticsReporter!

    override func setUp() {
        super.setUp()
        stubAdobeAnalyticsReporter = StubAdobeAnalyticsReporter()
        let analyticsFactory = AnalyticsReporterFactory(adobeAnalyticsReporter: stubAdobeAnalyticsReporter)
        let stubDataLoader = StubDataLoader()
        let dataLoaderFactory = StubDataLoaderFactory(stubDataLoader: stubDataLoader)
        let iflixServiceFactory = IFlixServiceFactory(dataLoaderFactory: dataLoaderFactory)
        let moviesDataLoader = iflixServiceFactory.makeMoviesAssetCollectionDataLoader()
        let presenter = AssetCollectionPresenter(assetDataLoader: moviesDataLoader)
        let dataSource = CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>()
        stubConfigureCollectionView = StubConfigureCollectionView()
        let appActions = AppMovieCollectionActions {}
        viewConroller = AssetCollectionViewController(presenter: presenter,
                                                      configureCollectionView: stubConfigureCollectionView,
                                                      dataSource: dataSource,
                                                      reporter: analyticsFactory.makeAssetCollectionReporter(),
                                                      loadingIndicator: LoadingIndicator(),
                                                      alert: InformationAlert(),
                                                      appActions: appActions)
    }
    
    override func tearDown() {
        stubAdobeAnalyticsReporter = nil
        stubConfigureCollectionView = nil
        viewConroller = nil
        super.tearDown()
    }

    func text_onViewAppear_configuresCollectionView() {
        viewConroller.beginAppearanceTransition(true, animated: false)
        XCTAssertTrue(stubConfigureCollectionView.didCallConfigure)
    }

    func text_onAppear_sendCorrectAnalyticsActionAndData() {
        viewConroller.beginAppearanceTransition(true, animated: false)
        XCTAssertEqual(stubAdobeAnalyticsReporter.sentActionList.count, 1)
        XCTAssertEqual(stubAdobeAnalyticsReporter.sentActionList[0].name, "MoviesCollectionShown")
        XCTAssertEqual(stubAdobeAnalyticsReporter.sentActionList[0].data?.keys.count, 1)
        XCTAssertEqual(stubAdobeAnalyticsReporter.sentActionList[0].data?["test"] as! String, "something")
    }



    // on view did appear calls analytics
    // on view did appear request presenter to update view
    // on each presenter response it does the correct thing
    // on cell selected correct app action is performed
    
}
