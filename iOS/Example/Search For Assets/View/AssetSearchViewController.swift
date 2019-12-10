//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit

class AssetSearchViewController: UIViewController {

    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    private let searchController: UISearchController
    private let presenter: AssetSearchPresenting
    private let loadingIndicator: LoadingIndicatorProtocol
    private let configureCollectionView: CollectionViewConfigurable
    private let dataSource: CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>
    private let reporter: LifecycleReporting

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(searchController: UISearchController,
         presenter: AssetSearchPresenting,
         loadingIndicator: LoadingIndicatorProtocol,
         configureCollectionView: CollectionViewConfigurable,
         dataSource: CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>,
         reporter: LifecycleReporting) {
        self.searchController = searchController
        self.presenter = presenter
        self.loadingIndicator = loadingIndicator
        self.configureCollectionView = configureCollectionView
        self.dataSource = dataSource
        self.reporter = reporter
        super.init(nibName: "AssetSearchViewController", bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reporter.viewDidAppear()
    }
}

// MARK:- Search for assets feature

extension AssetSearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else { return }
        searchTextDidUpdate(searchString: searchString)
    }


    private func searchTextDidUpdate(searchString: String) {
        presenter.updateSearchResults(searchString: searchString, running: .on(.main) { [weak self] response in
            switch response {
            case .loading(let showLoading):
                self?.showLoading(showLoading)
            case .information(let infoString):
                self?.showUserInformation(msg: infoString)
            case .success(let viewModelList):
                self?.reloadDataSource(viewModelList: viewModelList)
            }
        })
    }

    
    private func showLoading(_ loading: Bool) {
        loadingIndicator.statusBar(loading)
        loadingIndicator.view(view: self.view, loading: loading)
    }


    private func reloadDataSource(viewModelList: [AssetViewModel]) {
        let sections = CollectionSection<AssetViewModel>(title: nil, rows: viewModelList.map { CollectionRow<AssetViewModel>(data: $0, cellIdentifier: AssetCollectionViewCell.reuseIdentifier) })

        dataSource.reload(
            sections: [sections],
            cellIdentifier: { viewModel in
                return AssetCollectionViewCell.reuseIdentifier
            },
            configureCell: { (cell, viewModel) in
                cell.configure(viewModel: viewModel)
            },
            selectCell: { (_, _) in
                // add details app action
                // or remove this code and add collection view as child view controller
            }
        )
    }


    private func showUserInformation(msg: String) {
        informationLabel.text = msg
    }
}

// MARK:- View configuration

extension AssetSearchViewController {

    private func configureView() {
        title = "Search"
        view.backgroundColor = .white
        configureCollectionView.configure(collectionView: collectionView, nibName: "AssetCollectionViewCell", reuseIdentifier: AssetCollectionViewCell.reuseIdentifier, accessId: Accessibility.assetSearchCollectionView.id)
        dataSource.configure(collectionView: collectionView)
        collectionView.accessibilityIdentifier = Accessibility.searchCollectionView.id
        configureSearchController()
        navigationItem.searchController = searchController
    }
    

    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "enter title"
        searchController.searchBar.accessibilityIdentifier = Accessibility.searchBar.id
        definesPresentationContext = true
    }
}

// MARK:- Test target exposure

#if TEST_TARGET
    extension AssetSearchViewController {
        func _updateSearchText(searchString: String) {
            searchTextDidUpdate(searchString: searchString)
        }
    }
#endif
