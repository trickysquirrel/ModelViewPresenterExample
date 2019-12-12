//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit

/// Dummy Home View Controller with two buttons and accessibility for UI testing

class HomeViewController: UIViewController {

    private let appActions: HomeRouterActions?

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    init(appActions: HomeRouterActions) {
        self.appActions = appActions
        super.init(nibName: nil, bundle: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Selection"
        view.backgroundColor = .white

        addButtonToView(
            withTitle: "Movies",
            yPosition: 200,
            selector: #selector(moviesButtonSelected),
            accessID: Accessibility.selectionMoviesButton.id
        )

        addButtonToView(
            withTitle: "Search",
            yPosition: 300,
            selector: #selector(searchButtonSelected),
            accessID: Accessibility.selectionSearchButton.id
        )
    }

    @objc private func moviesButtonSelected() {
        appActions?.showMoviesCollection()
    }


    @objc private func searchButtonSelected() {
        appActions?.showSearch()
    }
}

// MARK:- View Configuration

extension HomeViewController {

    /// typically we would use contraints here, just doing the basics for now for a dummy VC
    private func addButtonToView(withTitle title: String, yPosition: CGFloat, selector: Selector, accessID: String) {
        let button = UIButton(frame: CGRect(x: 100, y: yPosition, width: 100, height: 50))
        button.setTitle(title, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.accessibilityIdentifier = accessID
        button.addTarget(self, action: selector, for: .primaryActionTriggered)
        view.addSubview(button)
    }
}
