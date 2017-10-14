//
//  Created by Richard Moult on 10/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example


class StubInformationAlert: InformationAlertProtocol {

    private(set) var title: String?
    private(set) var message: String?
    private(set) var presentingViewController: UIViewController?

    func displayAlert(title: String, message: String, presentingViewController: UIViewController?) {
        self.title = title
        self.message = message
        self.presentingViewController = presentingViewController
    }
}
