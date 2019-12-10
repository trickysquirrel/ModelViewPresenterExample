//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example


class StubAssetCollectionCoordinatorActions: AssetCollectionRouterActions {

    private(set) var didCallShowAlertOK: Bool?
    private(set) var didCallShowAlertWithTitle: String?
    private(set) var didCallShowAlertWithMsg: String?
    private(set) var didCallShowAlertWithVC: UIViewController?
    private(set) var didCallShowDetailsWithId: String?
    private(set) var didCallShowDetailsWithTitle: String?

    func showAlertOK(title: String, msg: String, presentingViewController: UIViewController) {
        didCallShowAlertOK = true
        didCallShowAlertWithTitle = title
        didCallShowAlertWithMsg = msg
        didCallShowAlertWithVC = presentingViewController
    }

    func showDetails(id: String, title: String) {
        didCallShowDetailsWithId = id
        didCallShowDetailsWithTitle = title // new addition need to test
    }

}

