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
        addMoviesSelectionButton()
    }


    private func addMoviesSelectionButton() {
        let button = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 50))
        button.setTitle("Movies", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.accessibilityIdentifier = Access.selectionMoviesButton.id
        button.addTarget(self, action: #selector(moviesButtonSelected), for: .primaryActionTriggered)
        view.addSubview(button)
    }

    
    @objc private func moviesButtonSelected() {
        appActions?.showMoviesCollection()
    }

}
