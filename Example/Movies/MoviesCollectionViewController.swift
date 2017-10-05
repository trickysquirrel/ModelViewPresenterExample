//
//  MoviesCollectionViewController.swift
//  Example
//
//  Created by Richard Moult on 4/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MovieCell"


class MoviesCollectionViewController: UICollectionViewController {

	private let presenter: MoviesPresenter
	private let dataSource: CollectionViewDataSource<MoviesCollectionViewCell, MoviesViewModel>
	private let showMovieDetailAction: ShowMovieDetailsAction
    private let reporter: MoviesReporter
    private let loadingIndicator: LoadingIndicatorProtocol
    private let alert: InformationAlertProtocol


	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	
	init(presenter: MoviesPresenter,
	     dataSource: CollectionViewDataSource<MoviesCollectionViewCell, MoviesViewModel>,
         reporter: MoviesReporter,
         loadingIndicator: LoadingIndicatorProtocol,
         alert: InformationAlertProtocol,
	     showMovieDetailAction: ShowMovieDetailsAction) {
		self.presenter = presenter
		self.dataSource = dataSource
		self.showMovieDetailAction = showMovieDetailAction
        self.reporter = reporter
        self.loadingIndicator = loadingIndicator
        self.alert = alert
		super.init(nibName: "MoviesCollectionViewController", bundle: nil)
	}

	
    override func viewDidLoad() {
        super.viewDidLoad()
		configureCollectionView()
		dataSource.configure(collectionView: collectionView)
		refreshView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reporter.viewShown()
    }


	private func refreshView() {
		presenter.updateView { [weak self] response in
			switch response {
			case .loading(let show):
                self?.loadingIndicator.show(show)
			case .success(let viewModels):
				observeDataSourceChanges()
				dataSource.resetRows(viewModels: viewModels, cellIdentifier: reuseIdentifier)
				break
			case .noResults(let title, let msg):
                self?.alert.displayAlert(title: title, message: msg, presentingViewController: self)
				break
			case .error(let title, let msg):
                self?.alert.displayAlert(title: title, message: msg, presentingViewController: self)
				break
			}
		}
	}


	private func observeDataSourceChanges() {

		dataSource.onEventConfigureCell { cell, viewModel in
			cell.configure(viewModel: viewModel)
		}

		dataSource.onEventItemSelected(selectCell: { [weak self] (viewModel, indexPath) in
            self?.showMovieDetailAction.perform()
		})
	}


}

// MARK:- Utils

private extension MoviesCollectionViewController {

	func configureCollectionView() {
		let nib = UINib.init(nibName: "MoviesCollectionViewCell", bundle: nil)
		self.collectionView?.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
		let collectionViewLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
		collectionViewLayout?.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
		collectionViewLayout?.invalidateLayout()
	}

}
