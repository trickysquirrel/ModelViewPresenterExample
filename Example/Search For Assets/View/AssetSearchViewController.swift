//
//  AssetSearchViewController.swift
//  Example
//
//  Created by Richard Moult on 18/10/17.
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


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(searchController: UISearchController,
         presenter: AssetSearchPresenting,
         loadingIndicator: LoadingIndicatorProtocol,
         configureCollectionView: CollectionViewConfigurable,
         dataSource: CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>) {
        self.searchController = searchController
        self.presenter = presenter
        self.loadingIndicator = loadingIndicator
        self.configureCollectionView = configureCollectionView
        self.dataSource = dataSource
        super.init(nibName: "AssetSearchViewController", bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter.navigationTitle()
        view.backgroundColor = .white
        configureCollectionView.configure(collectionView: collectionView, nibName: "AssetCollectionViewCell", reuseIdentifier: AssetCollectionViewCell.reuseIdentifier, accessId: Access.assetSearchCollectionView.id)
        dataSource.configure(collectionView: collectionView)
        configureSearchController()
        navigationItem.searchController = searchController
    }

    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = presenter.searchBarPlaceHolderText()
        definesPresentationContext = true
    }
}


extension AssetSearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else { return }
        searchTextDidUpdate(searchString: searchString)
    }


    private func searchTextDidUpdate(searchString: String) {
        presenter.updateSearchResults(searchString: searchString, updateHandler: { [weak self] response in
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
        dataSource.onEventConfigureCell { cell, viewModel in
            cell.configure(viewModel: viewModel)
        }
        dataSource.resetRows(viewModels: viewModelList, cellIdentifier: AssetCollectionViewCell.reuseIdentifier)
    }


    private func showUserInformation(msg: String) {
        informationLabel.text = msg
    }

}


#if TEST_TARGET
    extension AssetSearchViewController {
        func _updateSearchText(searchString: String) {
            searchTextDidUpdate(searchString: searchString)
        }
    }
#endif
