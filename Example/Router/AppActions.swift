//
//  AppActions.swift
//  Example
//
//  Created by Richard Moult on 4/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit

struct AppMovieCollectionActions {

    let alert: InformationAlertProtocol

    // pre load with extra info so view controller does not need to know about it
    let block: ((Int)->())

    func showAlertOK(title: String, msg: String, presentingViewController: UIViewController) {
        alert.displayAlert(title: title, message: msg, presentingViewController: presentingViewController)
    }

    func showDetails(id: Int) {
        // this could generate urls with are passed back rather than calling specific methods
		block(id)
	}
}
