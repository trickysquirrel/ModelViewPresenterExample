//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example


class StubAssetCollectionCoordinatorActions: AssetCollectionCoordinatorActions {

    private(set) var didCallShowAlertOK: Bool?
    private(set) var didCallShowAlertWithTitle: String?
    private(set) var didCallShowAlertWithMsg: String?
    private(set) var didCallShowAlertWithVC: UIViewController?
    private(set) var didCallShowDetailsWithId: Int?

    func showAlertOK(title: String, msg: String, presentingViewController: UIViewController) {
        didCallShowAlertOK = true
        didCallShowAlertWithTitle = title
        didCallShowAlertWithMsg = msg
        didCallShowAlertWithVC = presentingViewController
    }

    func showDetails(id: Int) {
        didCallShowDetailsWithId = id
    }

}

