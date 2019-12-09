//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation


protocol ThirdPartyAnalyticsReporting {
    func sendAction(name: String, data: [String:Any]?)
}

struct ThirdyPartyAnalyticsReporter: ThirdPartyAnalyticsReporting {

    func sendAction(name: String, data: [String:Any]?) {
        // call thirdy party library here and pass on the data
        // this should contain no logic just simply wrap 3rd party functions
    }
}
