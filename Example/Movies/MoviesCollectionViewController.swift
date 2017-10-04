//
//  MoviesCollectionViewController.swift
//  Example
//
//  Created by Richard Moult on 4/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"


class MoviesCollectionViewController: UICollectionViewController {

	private let presenter: MoviesPresenter
	private let dataSource = CollectionViewDataSource<UICollectionViewCell, MoviesViewModel>()


	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	
	init(presenter: MoviesPresenter) {
		self.presenter = presenter
		super.init(nibName: "MoviesCollectionViewController", bundle: nil)
	}

	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		dataSource.configure(collectionView: collectionView)
		observeDataSourceChanges()
		refreshView()
    }


	private func refreshView() {
		presenter.updateView { (response) in
			switch response {
			case .success(let viewModels):
				dataSource.resetRows(viewModels: viewModels, cellIdentifier: reuseIdentifier)
				break
			case .noResults:
				break
			case .error(let errorMsg):
				break
			}
		}
	}


	private func observeDataSourceChanges() {

		dataSource.onEventConfigureCell { cell, viewModel in
			cell.backgroundView?.backgroundColor = UIColor.red
			//cell.textLabel?.text = viewModel.title
		}

		dataSource.onEventItemSelected(selectCell: { [weak self] (viewModel, indexPath) in
			//self?.showRegistrationAction?.perform(location: viewModel.location)
		})
	}


}
