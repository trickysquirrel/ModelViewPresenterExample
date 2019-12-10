//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation

enum Accessibility: String {

    case selectionMoviesButton
    case selectionSearchButton
    case assetCollectionView
    case assetDetailsView
    case assetSearchCollectionView
    case loadingView

    var id: String {
        return self.rawValue
    }
}
