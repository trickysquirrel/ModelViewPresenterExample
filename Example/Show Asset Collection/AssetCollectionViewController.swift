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
    private let reporter: AssetReporter
    private let loadingIndicator: LoadingIndicatorProtocol
    private let alert: InformationAlertProtocol


	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	
	init(presenter: AssetCollectionPresenting,
	     dataSource: CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>,
         reporter: AssetReporter,
         loadingIndicator: LoadingIndicatorProtocol,
         alert: InformationAlertProtocol,
	     appActions: AppMovieCollectionActions) {
		self.presenter = presenter
		self.dataSource = dataSource
		self.appActions = appActions
        self.reporter = reporter
        self.loadingIndicator = loadingIndicator
        self.alert = alert
		super.init(nibName: "AssetCollectionViewController", bundle: nil)
	}

	
    override func viewDidLoad() {
        super.viewDidLoad()
		configureCollectionView()
		dataSource.configure(collectionView: collectionView)
        observeDataSourceChanges()
		refreshView()
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reporter.viewShown()
    }


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


	private func observeDataSourceChanges() {
		dataSource.onEventConfigureCell { cell, viewModel in
			cell.configure(viewModel: viewModel)
		}
		dataSource.onEventItemSelected(selectCell: { [weak self] (viewModel, indexPath) in
            self?.appActions.performShowDetails()
		})
	}
}


// MARK:- Presenter updates

private extension AssetCollectionViewController {

    func showLoading(_ loading: Bool) {
        loadingIndicator.statusBar(loading)
        loadingIndicator.view(view: self.view, loading: loading)
    }

    func reloadDataSource(viewModelList: [AssetViewModel]) {
        dataSource.resetRows(viewModels: viewModelList, cellIdentifier: reuseIdentifier)
    }

    func showUserAlert(title: String, msg: String) {
        alert.displayAlert(title: title, message: msg, presentingViewController: self)
    }
}


// MARK:- Utils

private extension AssetCollectionViewController {

	func configureCollectionView() {
		let nib = UINib.init(nibName: "AssetCollectionViewCell", bundle: nil)
		self.collectionView?.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
		let collectionViewLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
		collectionViewLayout?.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
		collectionViewLayout?.invalidateLayout()
	}
}