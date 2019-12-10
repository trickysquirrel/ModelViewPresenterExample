//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation


protocol AnalyticsReporting {
    func sendAction(name: String, data: [String:Any]?)
}

/// Given we had integrated with a 3rd party analytics lib we would inject that into this object
/// and wrap each of the 3rd party funcs with our own in app funcs.
/// This way we can easily substitute the analytics lib in our tests so we do not accidentally fire then during unit testing
/// Also if we ever decided to introduce a new analytics lib we only have this one file to handle the integration rather than it being spreadout throught the app

struct AnalyticsReporterFacade: AnalyticsReporting {

    func sendAction(name: String, data: [String:Any]?) {
        // call thirdy party library here and pass on the data
        // this should contain no logic just simply wrap 3rd party functions
    }
}
