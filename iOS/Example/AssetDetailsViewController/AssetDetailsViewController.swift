//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit

class AssetDetailsViewController: UIViewController {

    private let assetTitle: String

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(title: String) {
        self.assetTitle = title
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // This is a dummy view controller so this would be cleaned up
        title = "Details"
        view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 40, y: 200, width: 300, height: 100))
        label.text = assetTitle
        label.accessibilityIdentifier = Accessibility.assetDetailsView.id
        view.addSubview(label)
    }

}
