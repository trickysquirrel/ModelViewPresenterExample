//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit

class AssetDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // This is a dummy view controller so this would be extracted out, its here for now to help
        // with UI testing
        title = "Details"
        view.backgroundColor = .white

        let label = UILabel(frame: CGRect(x: 40, y: 200, width: 100, height: 100))
        label.text = "Asset Title"
        label.accessibilityIdentifier = Access.assetDetailsView.id
        view.addSubview(label)
    }

}
