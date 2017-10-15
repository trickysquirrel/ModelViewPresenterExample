//
//  Created by Richard Moult on 12/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation

enum Access: String {

    case selectionMoviesButton
    case assetCollectionView
    case assetDetailsView

    var id: String {
        return self.rawValue
    }
}
