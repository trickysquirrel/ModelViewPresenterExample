//
//  Copyright © 2019 Richard Moult. All rights reserved.
//

import UIKit

extension UIView {

    public func addConstraintsToFillSuperview(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        [
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach {
                $0.isActive = true
        }
    }
}
