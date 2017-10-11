//
//  MoviesCollectionViewController.swift
//  Example
//
//  Created by Richard Moult on 4/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MovieCell"


class AssetCollectionViewController: UICollectionViewController {

	private let presenter: AssetCollectionPresenting
	private let dataSource: CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>
	private let appActions: AppMovieCollectionActions
    private let reporter: MovieCollectionReporter
    private let loadingIndicator: LoadingIndicatorProtocol
    private let alert: InformationAlertProtocol
    private let configureCollectionView: CollectionViewConfigurable


	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	
	init(presenter: AssetCollectionPresenting,
         configureCollectionView: CollectionViewConfigurable,
	     dataSource: CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>,
         reporter: MovieCollectionReporter,
         loadingIndicator: LoadingIndicatorProtocol,
         alert: InformationAlertProtocol,
	     appActions: AppMovieCollectionActions) {
		self.presenter = presenter
        self.configureCollectionView = configureCollectionView
		self.dataSource = dataSource
		self.appActions = appActions
        self.reporter = reporter
        self.loadingIndicator = loadingIndicator
        self.alert = alert
		super.init(nibName: "AssetCollectionViewController", bundle: nil)
	}

	
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView.configure(collectionView: collectionView, nibName: "AssetCollectionViewCell", reuseIdentifier: reuseIdentifier)
		dataSource.configure(collectionView: collectionView)
		refreshView()
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reporter.viewShown()
    }
}


// MARK:- Feature refresh view

private extension AssetCollectionViewController {

    private func refreshView() {
        presenter.updateView(updateHandler: { [weak self] response in
            switch response {
            case .loading(let show):
                self?.showLoading(show)
            case .success(let viewModels):
                self?.reloadDataSource(viewModelList: viewModels)
            case .noResults(let title, let msg):
                self?.showUserAlert(title: title, msg: msg)
            case .error(let title, let msg):
                self?.showUserAlert(title: title, msg: msg)
                break
            }
        })
    }


    func showLoading(_ loading: Bool) {
        loadingIndicator.statusBar(loading)
        loadingIndicator.view(view: self.view, loading: loading)
    }


    func reloadDataSource(viewModelList: [AssetViewModel]) {
        dataSource.onEventConfigureCell { cell, viewModel in
            cell.configure(viewModel: viewModel)
        }
        dataSource.onEventItemSelected(selectCell: { [weak self] (viewModel, indexPath) in
            self?.appActions.performShowDetails(id: viewModel.id)
        })
        dataSource.resetRows(viewModels: viewModelList, cellIdentifier: reuseIdentifier)
    }


    func showUserAlert(title: String, msg: String) {
        alert.displayAlert(title: title, message: msg, presentingViewController: self)
    }
}
