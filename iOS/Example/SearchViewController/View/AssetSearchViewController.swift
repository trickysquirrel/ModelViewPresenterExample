//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit

class AssetSearchViewController: UIViewController {

    @IBOutlet weak var informationLabel: UILabel!

    private let searchController: UISearchController
    private let presenter: AssetSearchPresenting
    private let reporter: LifecycleReporting
    private let appActions: SearchRouterActions

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(searchController: UISearchController,
         presenter: AssetSearchPresenting,
         reporter: LifecycleReporting,
         appActions: SearchRouterActions) {
        self.searchController = searchController
        self.presenter = presenter
        self.reporter = reporter
        self.appActions = appActions
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
            case .information(let infoString):
                self?.showUserInformation(msg: infoString)
            case .success(let searchText):
                self?.showSearchResult(for: searchText)
            case .clearSearchResults:
                self?.removeSearchResult()
            }
        })
    }

    private func showSearchResult(for text: String) {
        let searchViewController = appActions.makeSearchResultsViewController(searchTerm: text)
        addChildViewController(searchViewController)
    }

    private func removeSearchResult() {
        removeFirstChildViewController()
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
        configureSearchController()
        navigationItem.searchController = searchController
    }
    

    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "enter title"
        searchController.searchBar.accessibilityTraits = UIAccessibilityTraits.searchField
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
