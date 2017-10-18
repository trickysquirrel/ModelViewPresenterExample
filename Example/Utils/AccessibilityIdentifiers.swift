//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation

enum Access: String {

    case selectionMoviesButton
    case selectionSearchButton
    case assetCollectionView
    case assetDetailsView
    case assetSearchCollectionView

    var id: String {
        return self.rawValue
    }
}
