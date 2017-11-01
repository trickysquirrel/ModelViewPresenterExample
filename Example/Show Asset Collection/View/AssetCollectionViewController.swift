//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit


class AssetCollectionViewController: UICollectionViewController {

	private let presenter: AssetCollectionPresenting
	private let dataSource: CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>
    private let reporter: MovieCollectionReporter
    private let loadingIndicator: LoadingIndicatorProtocol
    private let configureCollectionView: CollectionViewConfigurable
    private let appActions: AssetCollectionCoordinatorActions

    @available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    init(title: String,
         presenter: AssetCollectionPresenting,
         configureCollectionView: CollectionViewConfigurable,
	     dataSource: CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>,
         reporter: MovieCollectionReporter,
         loadingIndicator: LoadingIndicatorProtocol,
	     appActions: AssetCollectionCoordinatorActions) {
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
        configureCollectionView.configure(collectionView: collectionView, nibName: "AssetCollectionViewCell", reuseIdentifier: AssetCollectionViewCell.reuseIdentifier, accessId: Access.assetCollectionView.id)
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


    private func showLoading(_ loading: Bool) {
        loadingIndicator.statusBar(loading)
        loadingIndicator.view(view: self.view, loading: loading)
    }


    private func reloadDataSource(viewModelList: [AssetViewModel]) {
        dataSource.onEventConfigureCell { cell, viewModel in
            cell.configure(viewModel: viewModel)
        }
        dataSource.onEventItemSelected(selectCell: { [weak self] (viewModel, indexPath) in
            self?.appActions.showDetails(id: viewModel.id)
        })
        dataSource.resetRows(viewModels: viewModelList, cellIdentifier: AssetCollectionViewCell.reuseIdentifier)
    }


    private func showUserAlert(title: String, msg: String) {
        appActions.showAlertOK(title: title, msg: msg, presentingViewController: self)
    }
}

#if TEST_TARGET
extension AssetCollectionViewController {
    var _appActions: AssetCollectionCoordinatorActions? {
        get {
            return appActions
        }
    }
}
#endif
