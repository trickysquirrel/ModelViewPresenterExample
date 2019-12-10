//
//  Copyright © 2019 Richard Moult. All rights reserved.
//

import UIKit

public extension UIViewController {

    func addChildViewController(_ childViewController: UIViewController) {
        self.removeFirstChildViewController()
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.view.addConstraintsToFillSuperview(view)
        childViewController.didMove(toParent: self)
    }

    func removeFirstChildViewController() {
        guard let childViewController = children.first else { return }
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
}
