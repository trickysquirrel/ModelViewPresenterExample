//
//  AssetTypeSelectionViewController.swift
//  Example
//
//  Created by Richard Moult on 15/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit

class AssetTypeSelectionViewController: UIViewController {

    private let appActions: AssetTypeSelectionCoordinatorActions?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    init(appActions: AssetTypeSelectionCoordinatorActions) {
        self.appActions = appActions
        super.init(nibName: nil, bundle: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Selection"
        view.backgroundColor = .white
        addButtonToView(withTitle: "Movies", yPosition: 200, selector: #selector(moviesButtonSelected), accessID: Access.selectionMoviesButton.id)
        addButtonToView(withTitle: "Search", yPosition: 300, selector: #selector(searchButtonSelected), accessID: Access.selectionSearchButton.id)
    }

    private func addButtonToView(withTitle title: String, yPosition: CGFloat, selector: Selector, accessID: String) {
        let button = UIButton(frame: CGRect(x: 100, y: yPosition, width: 100, height: 50))
        button.setTitle(title, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.accessibilityIdentifier = accessID
        button.addTarget(self, action: selector, for: .primaryActionTriggered)
        view.addSubview(button)
    }

    
    @objc private func moviesButtonSelected() {
        appActions?.showMoviesCollection()
    }


    @objc private func searchButtonSelected() {
        appActions?.showSearch()
    }

}
