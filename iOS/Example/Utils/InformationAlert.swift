//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit

protocol InformationAlertProtocol {
    func displayAlert(title: String, message: String, presentingViewController: UIViewController?)
}


struct InformationAlert: InformationAlertProtocol {

    func displayAlert(title: String, message: String, presentingViewController: UIViewController?) {

        guard let presentingViewController = presentingViewController else { return }
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        presentingViewController.present(alertController, animated: true, completion: nil)
    }

}

