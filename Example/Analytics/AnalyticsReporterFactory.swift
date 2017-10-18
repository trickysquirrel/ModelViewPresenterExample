//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation


struct AnalyticsReporterFactory {

    let thirdPartyAnalyticsReporter: ThirdPartyAnalyticsReporting

    func makeAssetCollectionReporter() -> MovieCollectionReporter {
        return MovieCollectionReporter(thirdPartyAnalyticsReporter: thirdPartyAnalyticsReporter)
    }
}
