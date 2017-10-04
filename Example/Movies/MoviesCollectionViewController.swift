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


	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	
	init(presenter: MoviesPresenter, dataSource: CollectionViewDataSource<MoviesCollectionViewCell, MoviesViewModel>) {
		self.presenter = presenter
		self.dataSource = dataSource
		super.init(nibName: "MoviesCollectionViewController", bundle: nil)
	}

	
    override func viewDidLoad() {
        super.viewDidLoad()
		configureCollectionView()
		dataSource.configure(collectionView: collectionView)
		refreshView()
    }


	private func refreshView() {
		presenter.updateView { (response) in
			switch response {
			case .loading(_):
				break
			case .success(let viewModels):
				observeDataSourceChanges()
				dataSource.resetRows(viewModels: viewModels, cellIdentifier: reuseIdentifier)
				break
			case .noResults:
				break
			case .error:
				break
			}
		}
	}


	private func observeDataSourceChanges() {

		dataSource.onEventConfigureCell { cell, viewModel in
			cell.configure(viewModel: viewModel)
		}

		dataSource.onEventItemSelected(selectCell: { [weak self] (viewModel, indexPath) in
			//self?.showRegistrationAction?.perform(location: viewModel.location)
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
