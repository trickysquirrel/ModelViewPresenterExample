//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit


class AssetCollectionViewController: UICollectionViewController {

	private let presenter: AssetCollectionPresenting
	private let dataSource: CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>
    private let reporter: LifecycleReporting
    private let loadingIndicator: LoadingIndicatorProtocol
    private let configureCollectionView: CollectionViewConfigurable
    private let appActions: AssetCollectionRouterActions

    @available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    
    init(title: String,
         presenter: AssetCollectionPresenting,
         configureCollectionView: CollectionViewConfigurable,
	     dataSource: CollectionViewDataSource<AssetCollectionViewCell, AssetViewModel>,
         reporter: LifecycleReporting,
         loadingIndicator: LoadingIndicatorProtocol,
	     appActions: AssetCollectionRouterActions) {
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
        configureCollectionView.configure(collectionView: collectionView, nibName: "AssetCollectionViewCell", reuseIdentifier: AssetCollectionViewCell.reuseIdentifier, accessId: Accessibility.assetCollectionView.id)
		dataSource.configure(collectionView: collectionView)
		refreshView()
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reporter.viewDidAppear()
    }
}


// MARK:- Refresh view

private extension AssetCollectionViewController {

    private func refreshView() {
        presenter.updateView(running: .on(.main) { [weak self] response in
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
        let sections = CollectionSection<AssetViewModel>(rows: viewModelList)
        // There so many ways to do this.
        // This is just one example, the main idea is to keep the flow of the code close together making is easier for the
        // reader to follow the flow of the code and hiding the variable that holds the source of truth so it cannot be accidentally
        // manipulated and cause alot of those bugs we experience around data being out of sync with collection views
        dataSource.reload(
            sections: [sections],
            cellIdentifier: { viewModel in
                return AssetCollectionViewCell.reuseIdentifier
            },
            configureCell: { (cell, viewModel) in
                cell.configure(viewModel: viewModel)
            },
            selectCell: { [weak self] (viewModel, indexPath) in
                self?.appActions.showDetails(id: viewModel.id, title: viewModel.title)
            }
        )
    }


    private func showUserAlert(title: String, msg: String) {
        appActions.showAlertOK(title: title, msg: msg, presentingViewController: self)
    }
}

#if TEST_TARGET
extension AssetCollectionViewController {
    var _appActions: AssetCollectionRouterActions? {
        get {
            return appActions
        }
    }
}
#endif
