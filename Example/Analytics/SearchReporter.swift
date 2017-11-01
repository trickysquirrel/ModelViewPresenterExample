//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation

struct SearchReporter {

    let thirdPartyAnalyticsReporter: ThirdPartyAnalyticsReporting

    func viewShown() {
        thirdPartyAnalyticsReporter.sendAction(name: "SearchShown", data: nil)
    }
}
