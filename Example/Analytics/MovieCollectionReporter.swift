//
//  Created by Richard Moult on 5/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation

struct MovieCollectionReporter {

    let adobeAnalyticsReporter: AdobeAnalyticsReporting

    func viewShown() {
        adobeAnalyticsReporter.sendAction(name: "MoviesCollectionShown", data: ["test":"something"])
    }
}
