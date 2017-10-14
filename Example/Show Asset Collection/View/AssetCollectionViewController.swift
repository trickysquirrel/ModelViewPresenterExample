//
//  Created by Richard Moult on 4/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MovieCell"


class AssetCollectionViewController: UICollectionViewController {

    private let appActions: AppMovieCollectionActions   // exposed for router testing could add in appActions factory to solve this
	private let presenter: AssetCollectionPresenting
	private let dataSource: CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>
    private let reporter: MovieCollectionReporter
    private let loadingIndicator: LoadingIndicatorProtocol
    private let configureCollectionView: CollectionViewConfigurable


	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	
    init(title: String,
         presenter: AssetCollectionPresenting,
         configureCollectionView: CollectionViewConfigurable,
	     dataSource: CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>,
         reporter: MovieCollectionReporter,
         loadingIndicator: LoadingIndicatorProtocol,
	     appActions: AppMovieCollectionActions) {
		self.presenter = presenter
        self.configureCollectionView = configureCollectionView
		self.dataSource = dataSource
		self.appActions = appActions
        self.reporter = reporter
        self.loadingIndicator = loadingIndicator
		super.init(nibName: "AssetCollectionViewController", bundle: nil)
        self.title = title
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
            self?.appActions.showDetails(id: viewModel.id)
        })
        dataSource.resetRows(viewModels: viewModelList, cellIdentifier: reuseIdentifier)
    }


    func showUserAlert(title: String, msg: String) {
        appActions.showAlertOK(title: title, msg: msg, presentingViewController: self)
    }
}


#if TEST_TARGET
    extension AssetCollectionViewController {
        var _appActions: AppMovieCollectionActions {
            get {
                return appActions
            }
        }
    }
#endif
