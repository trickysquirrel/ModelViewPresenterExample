//
//  Created by Richard Moult on 5/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation

struct MovieCollectionReporter {

    let thirdPartyAnalyticsReporter: ThirdPartyAnalyticsReporting

    func viewShown() {
        thirdPartyAnalyticsReporter.sendAction(name: "MoviesCollectionShown", data: ["test":"something"])
    }
}
